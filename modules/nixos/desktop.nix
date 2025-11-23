{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.dconf.enable = true;
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
  ];
}
