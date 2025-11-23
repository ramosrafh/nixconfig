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
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = true;

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
