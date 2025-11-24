{ ... }: {
  imports = [
    ./desktop.nix
    # ./niri.nix
    ./wayland.nix
    ./fonts.nix
    ./networking.nix
    ./docker.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
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
}
