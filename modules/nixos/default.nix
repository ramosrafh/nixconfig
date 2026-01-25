{ pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./desktop.nix
    # ./niri.nix
    ./wayland.nix
    ./fonts.nix
    ./steam.nix
    ./networking.nix
    ./docker.nix
    ./users.nix
    ./greetd.nix
    ./hyprlock.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Use latest kernel for all hosts
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
    options = "--delete-older-than 7d";
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

  security.rtkit.enable = true;

  # Configure Java to use less memory system-wide
  environment.variables = {
    _JAVA_OPTIONS = "-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UseStringDeduplication";
  };
}
