{ pkgs, inputs, ... }: {
  imports = [
    ./themes/broken-pine-gtk.nix
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
    ./zed.nix
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
    nerd-fonts.symbols-only
    font-awesome
    onlyoffice-desktopeditors
    localsend
    gnumake
    gcc
    binutils
    awscli
    coreutils
    obsidian
    eog
    papers
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
    # audacity
    upower
    btrfs-assistant
    anydesk
    codex
    bruno

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

  dconf.settings = {
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
