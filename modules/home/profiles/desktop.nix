{ pkgs, inputs, ... }: {
  imports = [
    ./base.nix
    ../themes/broken-pine-gtk.nix
    ../programs/alacritty.nix
    ../programs/mpv.nix
    ../programs/zed.nix
    ../desktop/fuzzel.nix
    ../desktop/hypridle.nix
    ../desktop/hyprlock.nix
    ../desktop/kanshi.nix
    ../desktop/niri.nix
    ../desktop/swaync
    ../desktop/waybar.nix
    ../desktop/wireplumber.nix
  ];

  home.packages = with pkgs; [
    firefox
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    zed-editor
    font-awesome
    localsend
    obsidian
    eog
    papers
    piper
    google-fonts
    netbird-ui
    upower
    anydesk
    bruno
    onlyoffice-desktopeditors

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-pipewire-audio-capture
        obs-vkcapture
      ];
    })
  ];

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
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
