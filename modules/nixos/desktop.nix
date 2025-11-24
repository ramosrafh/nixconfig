{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable SOF firmware for audio
  hardware.firmware = [ pkgs.sof-firmware ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    wl-clipboard
    git
    helix
    btop
    ripgrep
    fd
    eza
    pavucontrol
    pulseaudio
  ];
}
