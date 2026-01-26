{ pkgs, lib, inputs, ... }:
let
  catppuccin-gtk-theme = pkgs.stdenv.mkDerivation {
    pname = "catppuccin-gtk-theme";
    version = "1.0.5";
    src = pkgs.fetchzip {
      url = "https://github.com/VanillaDaFur/catppuccin-gtk/releases/download/v1.0.5/catppuccin-mocha-mauve-standard.zip";
      sha256 = "sha256-QRZUhYcI7pC8+7oWGO8wAv7B+KrIyYYfZ0hPrAMQGKo=";
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/themes
      cp -r catppuccin-mocha-mauve-standard $out/share/themes/
    '';
  };
  themeName = "catppuccin-mocha-mauve-standard";
  themeDir = "${catppuccin-gtk-theme}/share/themes/${themeName}";
in {
  imports = [
    ./helix.nix
    ./yazi.nix
    ./fuzzel.nix
    ./zellij.nix
    ./terminal.nix
    ./fish.nix
    ./waybar.nix
    ./niri.nix
    ./kanshi.nix
    ./wireplumber.nix
    ./git.nix
    ./ssh.nix
    ./swaync
    ./hyprlock.nix
    ./hypridle.nix
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
    zed-editor
    vscodium
    dbeaver-bin
    bottom
    nautilus
    catppuccin-gtk-theme
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
    bitwarden-desktop
    eog
    libreoffice-fresh
    piper
    appflowy
    inkscape
    google-fonts
    # beekeeper-studio

    # OBS Studio com plugins para Wayland/PipeWire
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs                    # Captura de tela Wayland (wlroots)
        obs-pipewire-audio-capture # Captura de áudio via PipeWire
        obs-vkcapture             # Captura de jogos Vulkan/OpenGL
      ];
    })
  ];

  home.sessionVariables = {
    EDITOR = "helix";
    GTK_THEME = themeName;
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    # Disable graphical SSH password prompts, use terminal only
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
    # Limit Java memory usage for applications like DBeaver
    _JAVA_OPTIONS = "-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UseStringDeduplication";
  };

  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = catppuccin-gtk-theme;
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

  # Symlink theme to ~/.themes for GTK3 discovery
  home.file.".themes/${themeName}".source = themeDir;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = themeName;
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
