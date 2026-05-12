{ pkgs, inputs, ... }:
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
    ./mpv.nix
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    firefox
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    claude-code
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
    obsidian
    eog
    libreoffice-fresh
    piper
    appflowy
    inkscape
    google-fonts
    clickup
    discord
    unzip
    tabiew
    qgis
    rclone
    netbird-ui
    netbird
    audacity
    upower

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    })
  ];

  home.sessionVariables = {
    EDITOR = "helix";
    GTK_THEME = themeName;
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    # Force terminal-based SSH password prompts instead of gcr/askpass.
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
    GCR_SSH_ASKPASS = "";
    DISPLAY_FOR_SSH = "";
    _JAVA_OPTIONS = "-Xms128m -Xmx512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+UseStringDeduplication";
  };

  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = catppuccin-gtk-theme;
    };
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.file.".themes/${themeName}".source = themeDir;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = themeName;
      icon-theme = "Papirus-Dark";
    };
    "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
    "org/gtk/settings/file-chooser".sort-directories-first = true;
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      show-hidden-files = true;
    };
    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
      default-zoom-level = "standard";
    };
    "org/gnome/nautilus/icon-view".default-zoom-level = "standard";
  };

  home.pointerCursor = {
    gtk.enable = true;
    size = 24;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
