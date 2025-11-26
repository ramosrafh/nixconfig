{ pkgs, inputs, ... }: {
  imports = [
    ./helix.nix
    ./yazi.nix
    ./fuzzel.nix
    ./zellij.nix
    ./terminal.nix
    ./fish.nix
    ./waybar.nix
    ./swww.nix
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
    swww
    zed-editor
    vscodium
    dbeaver-bin
    bottom
    nautilus
    pavucontrol
    nerd-fonts.symbols-only
    font-awesome
    onlyoffice-desktopeditors
    localsend
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
