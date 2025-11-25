{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i915" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_YOUR_LUKS_UUID";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/vg0/root";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/vg0/root";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/vg0/root";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/vg0/root";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "noatime" ];
  };

  # NoCoW enabled in btrfs already
  fileSystems."/docker" = {
    device = "/dev/vg0/root";
    fsType = "btrfs";
    options = [ "subvol=@docker" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE_WITH_YOUR_BOOT_UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
