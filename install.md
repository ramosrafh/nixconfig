# NixOS Installation Guide

## Pre-Installation Checklist

Before running the installation commands, you need to update the following files with your specific values:

### 1. Hardware Configuration Files

Both `hosts/book/hardware.nix` and `hosts/desk/hardware.nix` need UUID replacements:

- **LUKS UUID**: After creating the encrypted partition, run `blkid` to get the UUID of your LUKS partition
  - Replace `REPLACE_WITH_YOUR_LUKS_UUID` in the `boot.initrd.luks.devices."cryptroot".device` line
  
- **Boot UUID**: After formatting the boot partition, run `blkid` to get the UUID of your boot partition
  - Replace `REPLACE_WITH_YOUR_BOOT_UUID` in the `fileSystems."/boot".device` line

### 2. Niri Configuration

Edit `dotfiles/.config/niri/config.kdl` (if you want to use it as a base):
- Update monitor configurations based on your actual displays
- Adjust keybindings to match your keyboard layout
- Set your wallpaper path

### 3. User Configuration

In `modules/nixos/users.nix`, the username is set to `ramos`. Change it if needed.

---

## Installation Steps

### 1. Boot NixOS Live ISO

Download and boot from the latest NixOS ISO.

### 2. Setup Disk Partitioning

```bash
DISK=/dev/nvme0n1  # Change to your disk (e.g., /dev/sda)

gdisk $DISK
o       # Create new GPT partition table
n       # New partition: +4G, ef00 (EFI System)
n       # New partition: remaining space, 8e00 (Linux LVM)
w       # Write changes and exit
```

### 3. Setup LUKS2 Encryption

```bash
cryptsetup luksFormat --type luks2 ${DISK}p2
cryptsetup open ${DISK}p2 cryptroot
```

### 4. Setup LVM

```bash
pvcreate /dev/mapper/cryptroot
vgcreate vg0 /dev/mapper/cryptroot
lvcreate -l 100%FREE -n root vg0
```

### 5. Format Boot Partition

```bash
mkfs.vfat -F32 -n BOOT ${DISK}p1
```

### 6. Create BTRFS with Subvolumes

```bash
mkfs.btrfs -L nixos /dev/vg0/root

mount /dev/vg0/root /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@docker

umount /mnt
```

### 7. Set no-COW for Docker Subvolume

```bash
mount -o subvol=@docker /dev/vg0/root /mnt
chattr +C /mnt
umount /mnt
```

### 8. Mount All Filesystems

```bash
mount -o subvol=@,compress=zstd,noatime /dev/vg0/root /mnt

mkdir -p /mnt/{boot,home,nix,var/log,var/lib/docker}

mount -o subvol=@home,compress=zstd,noatime /dev/vg0/root /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/vg0/root /mnt/nix
mount -o subvol=@log,compress=zstd,noatime /dev/vg0/root /mnt/var/log
mount -o subvol=@docker,noatime,nodatacow /dev/vg0/root /mnt/var/lib/docker

mount ${DISK}p1 /mnt/boot
```

### 9. Enable zram

This is configured in the flake automatically.

### 10. Clone Your Flake Configuration

```bash
mkdir -p /mnt/home/ramos
cd /mnt/home/ramos
git clone https://github.com/ramosrafh/nixconfig.git nixconfig
```

### 11. Update Hardware Configuration with UUIDs

```bash
blkid ${DISK}p1  # Note the UUID for boot
blkid ${DISK}p2  # Note the UUID for LUKS

# Edit the hardware.nix files with the correct UUIDs
nano /mnt/home/ramos/nixconfig/hosts/book/hardware.nix  # or hosts/desk/hardware.nix
```

### 12. Generate Hardware Configuration (Optional)

```bash
nixos-generate-config --root /mnt --show-hardware-config
```

Compare the output with your hardware.nix and adjust if needed.

### 13. Install NixOS with Flakes

For laptop (book):
```bash
nixos-install --flake /mnt/home/ramos/nixconfig#book
```

For desktop (desk):
```bash
nixos-install --flake /mnt/home/ramos/nixconfig#desk
```

### 14. Set Root Password

```bash
nixos-enter --root /mnt
passwd root
passwd ramos  # Set password for your user
exit
```

### 15. Install Limine Bootloader

```bash
nixos-enter --root /mnt
limine bios-install ${DISK}
exit
```

### 16. Reboot

```bash
umount -R /mnt
reboot
```

---

## Post-Installation

### 1. Setup Wallpapers

```bash
mkdir -p ~/.wallpapers
cp your-wallpaper.jpg ~/.wallpapers/current_wallpaper.jpg
```

### 2. Start Niri

If not started automatically:
```bash
niri
```

### 3. Configure Additional Services

All services are configured via the flake. To rebuild after changes:

```bash
sudo nixos-rebuild switch --flake ~/nixconfig#book  # or #desk
```

### 4. Update Flake

```bash
cd ~/nixconfig
nix flake update
sudo nixos-rebuild switch --flake .#book  # or #desk
```

---

## Troubleshooting

### Issue: Bootloader not found
- Ensure Limine was installed correctly: `limine bios-install ${DISK}`
- Check UEFI boot order in BIOS

### Issue: Cannot decrypt LUKS
- Verify the correct UUID in hardware.nix
- Check if `boot.initrd.luks.devices` is configured properly

### Issue: Niri won't start
- Check logs: `journalctl -u display-manager`
- Ensure all Wayland dependencies are installed

### Issue: Missing UUIDs
- Run `blkid` to get all partition UUIDs
- Update both hardware.nix files accordingly
