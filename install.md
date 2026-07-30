# Instalação do NixOS no Zenbook S 16

Procedimento para o ASUS Zenbook S 16 UM5606GA. Ele recria o mesmo layout do
notebook anterior:

| Camada | Layout |
| --- | --- |
| GPT | `EFI` de 4 GiB + `cryptroot` usando o restante do NVMe |
| Criptografia | LUKS2 em `cryptroot` |
| LVM | PV LUKS → VG `vg0` → LV `root` com 100% do espaço |
| Btrfs | `@`, `@home`, `@nix`, `@log` e `@docker` |
| Swap | somente zram; não há partição ou LV de swap |

Os arquivos NixOS usam os GPT labels `EFI` e `cryptroot`, portanto não é
necessário copiar UUIDs manualmente.

## Antes de iniciar

1. Use uma ISO NixOS unstable recente; esta plataforma AMD nova precisa de um
   kernel e firmware atuais.
2. No firmware do notebook, inicialize em modo UEFI, desative Secure Boot e
   Fast Boot, e selecione o pendrive no menu de boot.
3. Publique esta branch antes de trocar de máquina:

   ```bash
   git push -u origin switch/s16
   ```

4. Desconecte outros discos externos. O procedimento abaixo apaga totalmente o
   disco escolhido.

## Live USB e rede

No terminal do instalador:

```bash
sudo -i
loadkeys br-abnt2

lsblk -d -e 7 -o NAME,PATH,SIZE,MODEL,TRAN
```

Se precisar conectar ao Wi-Fi, use `nmtui`. Depois confirme a rede:

```bash
nmtui
ping -c 3 cache.nixos.org
```

## Identificar e apagar o NVMe

Defina `DISK` com o caminho mostrado pelo `lsblk`. No Zenbook com apenas o NVMe
interno, normalmente será `/dev/nvme0n1`.

```bash
DISK=/dev/nvme0n1

lsblk -o NAME,PATH,SIZE,MODEL,TYPE,FSTYPE,MOUNTPOINTS "$DISK"
test -b "$DISK" || { echo "Disco inexistente: $DISK"; exit 1; }

read -r -p "Digite exatamente $DISK para APAGAR esse disco: " CONFIRM
test "$CONFIRM" = "$DISK" || { echo "Cancelado"; exit 1; }
```

Somente depois de conferir modelo e capacidade, execute:

```bash
wipefs --all --force "$DISK"
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+4G -t 1:ef00 -c 1:EFI "$DISK"
sgdisk -n 2:0:0 -t 2:8309 -c 2:cryptroot "$DISK"
partprobe "$DISK"
udevadm settle

sgdisk -p "$DISK"
ls -l /dev/disk/by-partlabel/EFI /dev/disk/by-partlabel/cryptroot
```

## LUKS, LVM e Btrfs

O `luksFormat` pedirá confirmação e a nova senha de criptografia. Guarde essa
senha: ela será solicitada em cada boot.

```bash
cryptsetup luksFormat --type luks2 --label cryptroot "${DISK}p2"
cryptsetup open --allow-discards "${DISK}p2" cryptroot

pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -l 100%FREE -n root vg0

mkfs.vfat -F 32 -n EFI "${DISK}p1"
mkfs.btrfs -f -L nixos /dev/vg0/root
```

Crie os subvolumes:

```bash
mount /dev/vg0/root /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@docker
umount /mnt

mount -o subvol=@docker /dev/vg0/root /mnt
chattr +C /mnt
umount /mnt
```

Monte o layout final:

```bash
mount -o subvol=@,compress=zstd,noatime /dev/vg0/root /mnt
mkdir -p /mnt/boot /mnt/home /mnt/nix /mnt/var/log /mnt/docker
mount -o subvol=@home,compress=zstd,noatime /dev/vg0/root /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/vg0/root /mnt/nix
mount -o subvol=@log,compress=zstd,noatime /dev/vg0/root /mnt/var/log
mount -o subvol=@docker,noatime /dev/vg0/root /mnt/docker
mount /dev/disk/by-partlabel/EFI /mnt/boot
```

Confira tudo antes da instalação:

```bash
lsblk -f "$DISK"
pvs
vgs
lvs
findmnt -R /mnt
btrfs subvolume list /mnt
```

O resultado esperado contém `vg0-root` montado cinco vezes com os subvolumes
correspondentes e a partição FAT32 montada em `/mnt/boot`.

## Instalar a configuração

Use a branch que contém estas mudanças. Se elas já tiverem sido integradas à
`main`, troque o valor de `CONFIG_BRANCH` para `main`.

```bash
CONFIG_BRANCH=switch/s16

mkdir -p /mnt/home/ramos
git clone --branch "$CONFIG_BRANCH" --single-branch \
  https://github.com/ramosrafh/nixconfig.git \
  /mnt/home/ramos/nixconfig

nix flake check --no-build /mnt/home/ramos/nixconfig
nixos-install --flake /mnt/home/ramos/nixconfig#book --no-root-passwd
```

Defina a senha do usuário e ajuste a propriedade do repositório:

```bash
nixos-enter --root /mnt -c 'passwd ramos'
nixos-enter --root /mnt -c 'chown -R ramos:users /home/ramos'
sync
```

Finalize e remova o pendrive quando o firmware reiniciar:

```bash
umount -R /mnt
vgchange -an vg0
cryptsetup close cryptroot
reboot
```

## Conferência após o primeiro boot

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
findmnt -t btrfs,vfat
lscpu | sed -n '1,20p'
lspci -nnk | rg -A3 'VGA|Display|Audio|Network'
lsmod | rg 'amdgpu|amdxdna|kvm_amd'
systemctl --failed
```

Se o NVMe não aparecer no live USB, pare a instalação e use uma ISO mais nova.
Não escolha outro dispositivo por tentativa. O módulo Limine da configuração
instala o bootloader UEFI; não execute `limine bios-install` neste layout.
