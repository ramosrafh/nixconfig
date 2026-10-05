{ lib, primaryUser, ... }: {
  imports = [ ./server/cli.nix ];

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

  # Keep enough headroom for K3s images and application data on the 128 GB SSD.
  nix = {
    gc.options = lib.mkForce "--delete-older-than 14d";
    optimise.automatic = true;
    settings = {
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 10 * 1024 * 1024 * 1024;
    };
  };

  # Avoid accidental shutdowns during remote administration. This is a
  # guardrail, not a security boundary: an administrator with unrestricted
  # sudo remains able to change the system. Reboot commands stay available.
  security.sudo.extraConfig = ''
    Cmnd_Alias SERVER_POWEROFF = /run/current-system/sw/bin/poweroff, /run/current-system/sw/bin/halt, /run/current-system/sw/bin/shutdown, /run/current-system/sw/bin/systemctl poweroff, /run/current-system/sw/bin/systemctl halt
    ${primaryUser} ALL=(ALL:ALL) ALL, !SERVER_POWEROFF
  '';
}
