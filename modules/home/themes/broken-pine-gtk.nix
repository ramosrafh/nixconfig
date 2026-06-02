{ pkgs, ... }:
let
  brokenPine = import ../broken-pine.nix;
  colorReplacements = [
    { from = "#eff1f5"; to = brokenPine.text; }
    { from = "#cdd6f4"; to = brokenPine.textAlt; }
    { from = "#bac2de"; to = brokenPine.textAlt; }
    { from = "#a6adc8"; to = brokenPine.muted; }
    { from = "#6c7086"; to = brokenPine.disabled; }
    { from = "#585b70"; to = brokenPine.mutedAlt; }
    { from = "#45475a"; to = brokenPine.border; }
    { from = "#313244"; to = brokenPine.surfaceVariant; }
    { from = "#1e1e2e"; to = brokenPine.background; }
    { from = "#181825"; to = brokenPine.surface; }
    { from = "#11111b"; to = brokenPine.background; }

    { from = "#cba6f7"; to = brokenPine.blue; }
    { from = "#f38ba8"; to = brokenPine.red; }
    { from = "#fab387"; to = brokenPine.orange; }
    { from = "#f9e2af"; to = brokenPine.yellow; }
    { from = "#f9e2a7"; to = brokenPine.yellow; }
    { from = "#a6e3a1"; to = brokenPine.green; }
    { from = "#89dceb"; to = brokenPine.blue; }
    { from = "#89b4fa"; to = brokenPine.blue; }
    { from = "#74c7ec"; to = brokenPine.cyan; }
    { from = "#94e2d5"; to = brokenPine.property; }
    { from = "#f5c2e7"; to = brokenPine.attribute; }
    { from = "#eba0ac"; to = brokenPine.magenta; }
    { from = "#b4befe"; to = brokenPine.purple; }

    { from = "#ffffff"; to = brokenPine.textAlt; }
    { from = "#FFFFFF"; to = brokenPine.textAlt; }

    { from = "rgba(239, 241, 245,"; to = "rgba(215, 215, 255,"; }
    { from = "rgba(203, 166, 247,"; to = "rgba(155, 206, 214,"; }
    { from = "rgba(243, 139, 168,"; to = "rgba(234, 110, 146,"; }
    { from = "rgba(30, 30, 46,"; to = "rgba(17, 18, 21,"; }
    { from = "rgba(24, 24, 37,"; to = "rgba(23, 24, 26,"; }
    { from = "rgba(17, 17, 27,"; to = "rgba(17, 18, 21,"; }
    { from = "rgba(49, 50, 68,"; to = "rgba(35, 33, 50,"; }

    { from = upstreamThemeName; to = themeName; }
  ];
  replaceThemeColors = pkgs.lib.concatMapStringsSep "\n        " (replacement: ''
    substituteInPlace "$file" --replace-quiet '${replacement.from}' '${replacement.to}'
  '') colorReplacements;
  upstreamThemeName = "catppuccin-mocha-mauve-standard";
  themeName = "broken-pine";
  compactNautilusGtk4 = pkgs.writeText "broken-pine-compact-nautilus.css" ''
    window.background.csd headerbar,
    window.background.csd headerbar.titlebar,
    window.background.csd toolbarview > .top-bar,
    window.background.csd toolbarview > .top-bar headerbar,
    toolbarview > .top-bar,
    toolbarview > .top-bar headerbar,
    .nautilus-window headerbar,
    .nautilus-window headerbar.titlebar,
    .nautilus-window toolbarview > .top-bar,
    .nautilus-window toolbarview > .top-bar headerbar {
      min-height: 48px;
      padding: 0 6px;
      padding-top: 0;
      padding-bottom: 0;
      margin: 0;
      margin-top: 0;
      margin-bottom: 0;
    }

    window.background.csd headerbar > windowhandle,
    window.background.csd toolbarview > .top-bar > windowhandle,
    window.background.csd windowhandle,
    toolbarview > .top-bar > windowhandle,
    windowhandle,
    .nautilus-window headerbar > windowhandle,
    .nautilus-window toolbarview > .top-bar > windowhandle,
    .nautilus-window windowhandle {
      min-height: 48px;
      padding: 0;
      padding-top: 0;
      padding-bottom: 0;
      margin: 0;
      margin-top: 0;
      margin-bottom: 0;
    }

    window.background.csd headerbar box,
    window.background.csd headerbar centerbox,
    window.background.csd windowhandle box,
    window.background.csd windowhandle centerbox,
    window.background.csd toolbarview > .top-bar box,
    window.background.csd toolbarview > .top-bar centerbox,
    toolbarview > .top-bar box,
    toolbarview > .top-bar centerbox,
    .nautilus-window headerbar box,
    .nautilus-window headerbar centerbox,
    .nautilus-window windowhandle box,
    .nautilus-window windowhandle centerbox,
    .nautilus-window toolbarview > .top-bar box,
    .nautilus-window toolbarview > .top-bar centerbox {
      min-height: 0;
      padding-top: 0;
      padding-bottom: 0;
      margin-top: 0;
      margin-bottom: 0;
      border-spacing: 3px;
    }

    window.background.csd toolbarview > .top-bar .collapse-spacing .toolbar,
    window.background.csd toolbarview > .top-bar .collapse-spacing headerbar,
    toolbarview > .top-bar .collapse-spacing .toolbar,
    toolbarview > .top-bar .collapse-spacing headerbar,
    .nautilus-window toolbarview > .top-bar .collapse-spacing .toolbar,
    .nautilus-window toolbarview > .top-bar .collapse-spacing headerbar {
      padding-top: 0;
      padding-bottom: 0;
    }

    .nautilus-window .sidebar-pane toolbarview > .top-bar,
    .nautilus-window .sidebar-pane toolbarview > .top-bar.raised,
    .nautilus-window .sidebar-pane toolbarview > .top-bar headerbar,
    .nautilus-window .sidebar-pane headerbar {
      min-height: 62px;
      padding-top: 4px;
      padding-bottom: 4px;
    }

    .nautilus-window .sidebar-pane toolbarview > .top-bar > windowhandle,
    .nautilus-window .sidebar-pane headerbar > windowhandle,
    .nautilus-window .sidebar-pane windowhandle {
      min-height: 62px;
      padding-top: 0;
      padding-bottom: 0;
    }

    .nautilus-window .sidebar-pane headerbar button,
    .nautilus-window .sidebar-pane headerbar menubutton > button,
    .nautilus-window .sidebar-pane toolbarview > .top-bar button,
    .nautilus-window .sidebar-pane toolbarview > .top-bar menubutton > button {
      min-height: 50px;
      min-width: 50px;
      padding: 0 6px;
    }

    window.background.csd headerbar button,
    window.background.csd headerbar menubutton > button,
    window.background.csd headerbar splitbutton > button,
    window.background.csd headerbar splitbutton > menubutton > button,
    window.background.csd toolbarview > .top-bar button,
    window.background.csd toolbarview > .top-bar menubutton > button,
    window.background.csd toolbarview > .top-bar splitbutton > button,
    window.background.csd toolbarview > .top-bar splitbutton > menubutton > button,
    toolbarview > .top-bar button,
    toolbarview > .top-bar menubutton > button,
    toolbarview > .top-bar splitbutton > button,
    toolbarview > .top-bar splitbutton > menubutton > button,
    .nautilus-window headerbar button,
    .nautilus-window headerbar menubutton > button,
    .nautilus-window headerbar splitbutton > button,
    .nautilus-window headerbar splitbutton > menubutton > button,
    .nautilus-window toolbarview > .top-bar button,
    .nautilus-window toolbarview > .top-bar menubutton > button,
    .nautilus-window toolbarview > .top-bar splitbutton > button,
    .nautilus-window toolbarview > .top-bar splitbutton > menubutton > button {
      min-height: 34px;
      min-width: 34px;
      padding: 0 4px;
      padding-top: 0;
      padding-bottom: 0;
      margin: 0;
      margin-top: 0;
      margin-bottom: 0;
    }

    window.background.csd headerbar button.image-button,
    window.background.csd headerbar menubutton.image-button > button,
    window.background.csd toolbarview > .top-bar button.image-button,
    window.background.csd toolbarview > .top-bar menubutton.image-button > button,
    toolbarview > .top-bar button.image-button,
    toolbarview > .top-bar menubutton.image-button > button,
    .nautilus-window headerbar button.image-button,
    .nautilus-window headerbar menubutton.image-button > button,
    .nautilus-window toolbarview > .top-bar button.image-button,
    .nautilus-window toolbarview > .top-bar menubutton.image-button > button {
      padding-left: 0;
      padding-right: 0;
    }

    window.background.csd headerbar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    window.background.csd headerbar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button,
    window.background.csd toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    window.background.csd toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button,
    toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button,
    .nautilus-window headerbar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .nautilus-window headerbar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button,
    .nautilus-window toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .nautilus-window toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button {
      min-height: 36px;
      min-width: 40px;
      padding: 0 4px;
      margin-top: 0;
      margin-bottom: 0;
    }

    window.background.csd headerbar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) image,
    window.background.csd headerbar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button image,
    window.background.csd toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) image,
    window.background.csd toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button image,
    toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) image,
    toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button image,
    .nautilus-window headerbar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) image,
    .nautilus-window headerbar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button image,
    .nautilus-window toolbarview > .top-bar button.image-button:not(.close):not(.minimize):not(.maximize):not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) image,
    .nautilus-window toolbarview > .top-bar menubutton.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > button image {
      -gtk-icon-size: 15px;
    }

    window.background.csd headerbar button image,
    window.background.csd headerbar menubutton > button image,
    window.background.csd toolbarview > .top-bar button image,
    window.background.csd toolbarview > .top-bar menubutton > button image,
    toolbarview > .top-bar button image,
    toolbarview > .top-bar menubutton > button image,
    .nautilus-window headerbar button image,
    .nautilus-window headerbar menubutton > button image,
    .nautilus-window toolbarview > .top-bar button image,
    .nautilus-window toolbarview > .top-bar menubutton > button image {
      -gtk-icon-size: 16px;
    }

    windowcontrols {
      border-spacing: 3px;
      margin-left: 2px;
      margin-right: 2px;
    }

    windowcontrols > button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.image-button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    headerbar.default-decoration windowcontrols > button {
      min-height: 20px;
      min-width: 20px;
      padding: 0;
      margin: 0 2px;
      border-radius: 999px;
    }

    windowcontrols > button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque).image-button > image {
      min-height: 12px;
      min-width: 12px;
      padding: 0;
      margin: 0;
      -gtk-icon-size: 12px;
    }

    .nautilus-window #NautilusPathBar {
      min-height: 48px;
      padding-top: 0;
      padding-bottom: 0;
      margin-top: 0;
      margin-bottom: 0;
    }

    .nautilus-window #NautilusPathButton {
      min-height: 48px;
      padding: 0 8px;
      padding-top: 0;
      padding-bottom: 0;
      margin-top: 0;
      margin-bottom: 0;
    }

    windowcontrols > button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.image-button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.image-button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque),
    .content-pane headerbar windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) {
      min-height: 20px;
      min-width: 20px;
      padding: 0;
      color: #ea6e92;
      background-color: transparent;
      background-image: none;
      box-shadow: none;
    }

    windowcontrols > button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.image-button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.image-button.close:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image {
      min-height: 14px;
      min-width: 14px;
      padding: 0;
      margin: 0;
      opacity: 1;
      color: #ea6e92;
      background-color: #ea6e92;
      background-image: none;
      border-radius: 999px;
      -gtk-icon-size: 12px;
      -gtk-icon-source: none;
    }

    windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.image-button.close:hover:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image {
      color: #ff7aa2;
      background-color: #ff7aa2;
      box-shadow: 0 0 0 3px rgba(234, 110, 146, 0.18);
    }

    windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image,
    .content-pane headerbar windowcontrols > button.image-button.close:active:not(.raised):not(.suggested-action):not(.destructive-action):not(.opaque) > image {
      color: #d95f83;
      background-color: #d95f83;
      box-shadow: 0 0 0 3px rgba(234, 110, 146, 0.12);
    }
  '';
  broken-pine-gtk-theme = pkgs.stdenv.mkDerivation {
    pname = "broken-pine-gtk-theme";
    version = "1.0.5";
    src = pkgs.fetchzip {
      url = "https://github.com/VanillaDaFur/catppuccin-gtk/releases/download/v1.0.5/catppuccin-mocha-mauve-standard.zip";
      sha256 = "sha256-QRZUhYcI7pC8+7oWGO8wAv7B+KrIyYYfZ0hPrAMQGKo=";
      stripRoot = false;
    };
    installPhase = ''
      mkdir -p $out/share/themes
      cp -r ${upstreamThemeName} $out/share/themes/${themeName}

      while IFS= read -r file; do
        ${replaceThemeColors}
      done < <(find $out/share/themes/${themeName} -type f \( -name '*.css' -o -name '*.svg' -o -name '*.theme' \))

      substituteInPlace $out/share/themes/${themeName}/index.theme \
        --replace-quiet 'Name=broken-pine' 'Name=Broken Pine' \
        --replace-quiet 'Comment=An Flat Gtk+ theme based on Elegant Design' 'Comment=Broken Pine theme based on Catppuccin Mocha Mauve'

      cat ${compactNautilusGtk4} >> $out/share/themes/${themeName}/gtk-4.0/gtk.css
      cat ${compactNautilusGtk4} >> $out/share/themes/${themeName}/gtk-4.0/gtk-dark.css
    '';
  };
  themeDir = "${broken-pine-gtk-theme}/share/themes/${themeName}";
in {
  home.packages = with pkgs; [
    broken-pine-gtk-theme
    gnome-themes-extra
    adw-gtk3
    adwaita-icon-theme
    libadwaita
    papirus-icon-theme
  ];

  home.sessionVariables.GTK_THEME = "${themeName}:dark";

  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = broken-pine-gtk-theme;
    };
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.file.".themes/${themeName}" = {
    source = themeDir;
    force = true;
  };
  home.file.".config/gtk-4.0/gtk.css" = {
    source = "${themeDir}/gtk-4.0/gtk.css";
    force = true;
  };
  home.file.".config/gtk-4.0/gtk-dark.css" = {
    source = "${themeDir}/gtk-4.0/gtk-dark.css";
    force = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = themeName;
    icon-theme = "Papirus-Dark";
  };
}
