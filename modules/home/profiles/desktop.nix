{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  vesper = import ../themes/vesper.nix;
  termfilechooserYazi = pkgs.writeShellScript "termfilechooser-yazi" ''
    export PATH=${lib.makeBinPath [
      pkgs.bash
      pkgs.coreutils
      pkgs.gnused
      pkgs.kitty
      pkgs.yazi
    ]}
    export TERMCMD="${pkgs.kitty}/bin/kitty --title termfilechooser"
    exec ${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh "$@"
  '';

  strata = pkgs.stdenvNoCC.mkDerivation {
    pname = "strata";
    version = "0.8.1";

    src = pkgs.fetchurl {
      url = "https://github.com/lgse/strata/releases/download/v0.8.1/strata-0.8.1-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-E14SHfP1kSRnJBEDsNbh/ISC2YHesp3Ox8322lQOOC4=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
      wrapGAppsHook3
    ];

    buildInputs = with pkgs; [
      cairo
      fontconfig
      gdk-pixbuf
      glib
      graphene
      gsettings-desktop-schemas
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-good
      gtk4
      gtksourceview5
      pango
      poppler
    ];

    installPhase = ''
      install -Dm755 strata $out/bin/strata
      install -Dm644 io.github.lgse.Strata.desktop \
        $out/share/applications/io.github.lgse.Strata.desktop
      install -Dm644 io.github.lgse.Strata.svg \
        $out/share/icons/hicolor/scalable/apps/io.github.lgse.Strata.svg
    '';

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.bubblewrap
            pkgs.ffmpeg
            pkgs.ffmpegthumbnailer
          ]
        }
      )
    '';

    meta = {
      description = "A fast, keyboard-first file manager for Linux";
      homepage = "https://github.com/lgse/strata";
      license = pkgs.lib.licenses.gpl3Only;
      mainProgram = "strata";
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  imports = [
    ./development.nix
    ../themes/broken-pine-gtk.nix
    ../programs/alacritty.nix
    ../programs/mpv.nix
    ../programs/zed.nix
    ../programs/visigrid.nix
    ../desktop/fuzzel.nix
    ../desktop/hypridle.nix
    ../desktop/hyprlock.nix
    ../desktop/kanshi.nix
    ../desktop/netbird-profile.nix
    ../desktop/niri.nix
    ../desktop/swaync
    ../desktop/waybar.nix
  ];

  xdg.configFile."strata/themes/vesper.toml".text = ''
    name = "Vesper"
    background = "${vesper.background}"
    surface = "${vesper.surface}"
    text = "${vesper.text}"
    accent = "${vesper.yellow}"
    danger = "${vesper.red}"
    muted = "${vesper.surfaceVariant}"
    highlight = "${vesper.surfaceActive}"
    border = "${vesper.border}"
    dim_text = "${vesper.muted}"
  '';

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${termfilechooserYazi}
    default_dir=${config.home.homeDirectory}/Downloads
  '';

  home.activation.setDesktopDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set_default() {
      ${pkgs.xdg-utils}/bin/xdg-mime default "$2" "$1"
    }

    set_default text/csv visigrid.desktop
    set_default text/tab-separated-values visigrid.desktop
    set_default application/vnd.openxmlformats-officedocument.spreadsheetml.sheet visigrid.desktop
    set_default application/vnd.ms-excel visigrid.desktop
    set_default application/vnd.ms-excel.sheet.binary.macroenabled.12 visigrid.desktop
    set_default application/vnd.oasis.opendocument.spreadsheet visigrid.desktop
    set_default application/x-visigrid visigrid.desktop
    set_default application/x-visigrid-sheet visigrid.desktop
    set_default application/pdf org.gnome.Papers.desktop
  '';

  home.activation.selectStrataVesper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="$HOME/.config/strata/settings.toml"
    if [[ -f "$settings" ]]; then
      ${pkgs.gnused}/bin/sed -i \
        -e 's/^mode = .*/mode = "theme"/' \
        -e 's/^theme = .*/theme = "vesper"/' \
        -e 's/^single_click_previews = .*/single_click_previews = true/' \
        "$settings"
    else
      mkdir -p "$(dirname "$settings")"
      printf '%s\n' \
        'mode = "theme"' \
        'theme = "vesper"' \
        'single_click_previews = true' \
        > "$settings"
    fi
  '';

  home.packages = with pkgs; [
    strata
    firefox
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    inputs.query-on.packages."${pkgs.stdenv.hostPlatform.system}".default
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
