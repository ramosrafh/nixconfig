{ primaryUser, ... }: {
  imports = [
    ./bluetooth.nix
    ./desktop.nix
    ./development.nix
    ./fonts.nix
    ./greetd.nix
    ./hyprlock.nix
    ./niri.nix
  ];

  networking.networkmanager.enable = true;
  users.users.${primaryUser}.extraGroups = [
    "networkmanager"
    "video"
    "audio"
    "storage"
  ];
  security.sudo.wheelNeedsPassword = false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=0"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=0"
    "udev.log_priority=0"
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.swappiness" = 180;
  };

  security.rtkit.enable = true;
}
