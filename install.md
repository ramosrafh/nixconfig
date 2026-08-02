# Instalação do `book`

Instalação do ASUS Zenbook S 16 com Disko, LUKS2, Btrfs, Lanzaboote e TPM2.
O script apaga o disco selecionado por completo.

Layout criado:

- EFI de 4 GiB e LUKS2 no restante do NVMe;
- Btrfs sem LVM, com `@`, `@home`, `@nix`, `@cache`, `@docker` e
  `@home-snapshots`;
- snapshots do `/home`: 24 horários, 7 diários e 4 semanais;
- somente zram, sem swap em disco e sem hibernação;
- Docker com `overlay2` em `/docker`.

## 1. Publicar a configuração

Na máquina atual:

```bash
cd ~/nixconfig
git add .
git commit -m "storage: add Disko Secure Boot and TPM2 setup"
git push -u origin switch/s16
```

## 2. Instalar pelo live USB

No firmware, habilite UEFI e TPM/fTPM. Deixe Secure Boot e Fast Boot
desabilitados por enquanto.

No live USB:

```bash
sudo -i
timedatectl set-ntp true
loadkeys us
nmtui
ping -c 3 cache.nixos.org

git clone --branch switch/s16 --single-branch \
  https://github.com/ramosrafh/nixconfig.git /tmp/nixconfig
cd /tmp/nixconfig

lsblk -d -e 7 -o NAME,PATH,SIZE,MODEL,SERIAL,TRAN
```

Confirme pelo modelo e capacidade qual é o NVMe inteiro. Troque o caminho se
necessário e execute:

```bash
DISK=/dev/nvme0n1
bash scripts/install-book "$DISK"
```

O script valida que o caminho representa um disco inteiro e exige que ele seja
digitado novamente antes de apagá-lo. `/dev/disk/by-id/...` também pode ser
usado, especialmente quando há vários discos conectados.

Durante a execução:

1. Escolha a senha LUKS.
2. Guarde a recovery key/QR code fora do notebook.
3. Defina a senha do usuário indicado por `primaryUser` no flake.

Ao terminar, execute `reboot` e retire o live USB. O primeiro boot ainda pede a
senha LUKS.

## 3. Ativar Secure Boot

No NixOS instalado, confira as assinaturas e faça backup de `/var/lib/sbctl`
em uma mídia externa criptografada:

```bash
sudo sbctl status
sudo sbctl verify
systemctl reboot --firmware-setup
```

No firmware ASUS:

1. Entre em Setup Mode ou remova somente a Platform Key (`PK`).
2. Não use “Clear All Secure Boot Keys”, pois isso pode apagar o `dbx`.
3. Se necessário, selecione “Windows UEFI Mode”.
4. Salve e inicialize o NixOS.

Inscreva as chaves e reinicie:

```bash
sudo sbctl enroll-keys --microsoft
reboot
```

Confirme:

```bash
bootctl status
sudo sbctl status
sudo sbctl verify
```

O resultado esperado é `Secure Boot: enabled (user)`.

## 4. Ativar TPM2 autounlock

Somente depois de iniciar com Secure Boot ativo:

```bash
PCRLOCK=/run/current-system/systemd/lib/systemd/systemd-pcrlock
"$PCRLOCK" is-supported
sudo test -s /var/lib/systemd/pcrlock.json

# Teste a senha LUKS e confira se a recovery key está registrada.
sudo cryptsetup open --test-passphrase /dev/disk/by-partlabel/cryptroot
sudo cryptsetup luksDump /dev/disk/by-partlabel/cryptroot

sudo systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-with-pin=false \
  --tpm2-pcrlock=/var/lib/systemd/pcrlock.json \
  /dev/disk/by-partlabel/cryptroot
```

`is-supported` precisa responder `yes`. A inscrição adiciona o TPM sem remover
a senha nem a recovery key.

Faça o backup do cabeçalho LUKS em uma mídia externa já montada:

```bash
HEADER_BACKUP="/run/media/$USER/RECOVERY/book-cryptroot-header.img"
sudo cryptsetup luksHeaderBackup /dev/disk/by-partlabel/cryptroot \
  --header-backup-file "$HEADER_BACKUP"
reboot
```

Troque `RECOVERY` pelo label real da mídia externa. Não deixe esse arquivo no
notebook. O próximo boot deve chegar à tela de login sem pedir a senha LUKS. Se
o TPM falhar, a senha continua disponível como fallback.

## 5. Conferência final

```bash
findmnt / /boot /home "$HOME/.cache" /home/.snapshots /nix /docker
sudo snapper -c home list
systemctl list-timers 'snapper-*'
docker info --format 'driver={{.Driver}} root={{.DockerRootDir}}'
systemctl --failed
```

Esperado:

- snapshots do `/home`: 24 horários, 7 diários e 4 semanais;
- `~/.cache` fora dos snapshots;
- Docker: `driver=overlay2 root=/docker`;
- teclado US no console e no Niri;
- fallback para a senha LUKS se o TPM não desbloquear o disco.
