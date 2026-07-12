{ ... }: {
  imports = [
    ./adb.nix
    ./bluetooth.nix
    ./desktop.nix
    ./niri.nix
    ./fonts.nix
    ./networking.nix
    ./users.nix
    ./greetd.nix
    ./hyprlock.nix
    ./nix-ld.nix
  ];

  nix.settings = {
    cores = 0;
    max-jobs = "auto";
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.limine = {
    enable = true;
    efiSupport = true;

    maxGenerations = 3;

    style = {
      wallpapers = [];
      interface.helpHidden = true;
      interface.branding = "NixOS";
    };
  };

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=0"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=0"
    "udev.log_priority=0"
    "mem_sleep_default=s2idle"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
  };

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
