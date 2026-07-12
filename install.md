# NixOS Installation

The commands below erase the selected disk. Set `DISK` correctly and replace
the UUIDs in the selected host's `hardware.nix` before installing.

```bash
sudo -i
DISK=/dev/nvme0n1

sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+4G -t 1:ef00 -c 1:EFI "$DISK"
sgdisk -n 2:0:0 -t 2:8309 -c 2:cryptroot "$DISK"

cryptsetup luksFormat --type luks2 "${DISK}p2"
cryptsetup open "${DISK}p2" cryptroot

pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -l 100%FREE -n root vg0

mkfs.vfat -F 32 -n EFI "${DISK}p1"
mkfs.btrfs -L nixos /dev/vg0/root

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

mount -o subvol=@,compress=zstd,noatime /dev/vg0/root /mnt
mkdir -p /mnt/{boot,home,nix,var/log,docker}
mount -o subvol=@home,compress=zstd,noatime /dev/vg0/root /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/vg0/root /mnt/nix
mount -o subvol=@log,compress=zstd,noatime /dev/vg0/root /mnt/var/log
mount -o subvol=@docker,noatime /dev/vg0/root /mnt/docker
mount "${DISK}p1" /mnt/boot

mkdir -p /mnt/home/ramos
git clone https://github.com/ramosrafh/nixconfig.git /mnt/home/ramos/nixconfig

blkid "${DISK}p1"
blkid "${DISK}p2"
```

Update the boot and LUKS UUIDs in `hosts/book/hardware.nix` or
`hosts/desk/hardware.nix`, then install:

```bash
nixos-install --flake /mnt/home/ramos/nixconfig#book
# or
nixos-install --flake /mnt/home/ramos/nixconfig#desk

nixos-enter --root /mnt -c 'passwd ramos'
umount -R /mnt
reboot
```

The NixOS Limine module installs and updates the UEFI bootloader. Do not run
`limine bios-install` on this layout.
