{ lib, ... }: {
  boot.loader.timeout = 3;

  hardware.enableRedistributableFirmware = true;
  services.fstrim.enable = true;
  networking.useDHCP = lib.mkDefault true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  boot.kernel.sysctl."vm.swappiness" = 10;
  services.journald.extraConfig = "SystemMaxUse=1G";
}
