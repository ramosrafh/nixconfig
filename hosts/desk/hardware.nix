{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/b57fe4ad-f15c-44f3-94df-ad7234b8a998";
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
    device = "/dev/disk/by-uuid/134C-AC1A";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
