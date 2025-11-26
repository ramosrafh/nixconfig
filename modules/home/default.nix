{ pkgs, inputs, ... }: {
  imports = [
    ./helix.nix
    ./yazi.nix
    ./fuzzel.nix
    ./zellij.nix
    ./terminal.nix
    ./fish.nix
    ./waybar.nix
    ./swaybg.nix
    ./niri.nix
    ./git.nix
  ];

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    firefox
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    alacritty
    fuzzel
    zellij
    yazi
    waybar
    swaybg
    zed-editor
    vscodium
    dbeaver-bin
    bottom
    nautilus
    nerd-fonts.symbols-only
    font-awesome
    onlyoffice-desktopeditors
    localsend
    papirus-icon-theme
  ];

  home.sessionVariables = {
    EDITOR = "helix";
    GTK_THEME = "Adwaita:dark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    size = 24;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
