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
    ./ssh.nix
    ./fnott
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
    gnome-themes-extra
    adw-gtk3
    adwaita-icon-theme
    libadwaita
    nerd-fonts.symbols-only
    font-awesome
    onlyoffice-desktopeditors
    localsend
    papirus-icon-theme
    gnumake
    gcc
    binutils
    awscli
    coreutils
  ];

  home.sessionVariables = {
    EDITOR = "helix";
    GTK_THEME = "Adwaita-dark";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
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
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
    };
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      show-hidden-files = true;
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
      default-zoom-level = "standard";
    };
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "standard";
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
