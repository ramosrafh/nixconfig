{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i915" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/10e6b301-944e-44e2-b575-ea7175b1bf18";
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
    device = "/dev/disk/by-uuid/742A-04C2";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
