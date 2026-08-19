{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "sd_mod"
    "uas"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # Broadcom BCM4360 wifi: use the proprietary `wl` driver. NixOS 26.05 dropped
  # the hardware.broadcom-sta option, so wire it up manually.
  boot.blacklistedKernelModules = [ "b43" "bcma" "brcmsmac" "brcmfmac" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
