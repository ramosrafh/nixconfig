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
    zed-editor
    dbeaver-bin
    bottom
    font-awesome
    onlyoffice-desktopeditors
    localsend
    awscli
    obsidian
    eog
    papers
    libreoffice-fresh
    piper
    inkscape
    gimp
    google-fonts
    clickup
    discord
    unzip
    tabiew
    rclone
    netbird-ui
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
  };

  dconf.settings = {
    "org/blueman/general".symbolic-status-icons = true;
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
    enable = true;
    gtk.enable = true;
    size = 24;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
}
