{ pkgs, hostConfig ? "desk", ... }:
let
  brokenPine = import ./broken-pine.nix;
  wallpaper = "${../../assets/wallpapers/current_wallpaper.jpg}";
  keyboardLayout = if hostConfig == "book" then "br" else "us";
  keyboardVariant = if hostConfig == "book" then "" else "intl";
in {
  programs.niri.settings = {
    input = {
      focus-follows-mouse.enable = false;
      mouse.accel-speed = 0.15;
      touchpad = {
        tap = true;
        dwt = true;
        natural-scroll = false;
      };
      keyboard.xkb = {
        layout = keyboardLayout;
        variant = keyboardVariant;
        options = "grp:alt_space_toggle,caps:swapescape,altwin:swap_lalt_lwin";
      };
    };

    layout = {
      gaps = 14;
      center-focused-column = "on-overflow";
      background-color = "transparent";
      preset-column-widths = [
        { proportion = 0.5; }
        { proportion = 0.66667; }
        { proportion = 0.8; }
      ];
      default-column-width = { proportion = 0.6; };
      focus-ring = {
        width = 2;
        active.color = "#${brokenPine.withAlpha brokenPine.blue "80"}";
        inactive.color = "#${brokenPine.withAlpha brokenPine.surfaceActive "40"}";
      };
      border.enable = false;
      struts = {
        left = 48;
        right = 48;
      };
    };

    spawn-at-startup = [
      { command = [ "sh" "-c" "awww-daemon & sleep 1 && awww img ${wallpaper}" ]; }
      { command = [ "sh" "-c" "sleep 1.0 && waybar" ]; }
      { command = [ "swaync" "--skip-system-css" ]; }
    ];

    layer-rules = [
      {
        matches = [{ namespace = "^awww-daemon$"; }];
        place-within-backdrop = true;
      }
    ];

    prefer-no-csd = true;
    screenshot-path = "~/Pictures/screenshots/%Y-%m-%d %H-%M-%S.png";

    window-rules = [
      {
        open-focused = true;
        draw-border-with-background = false;
        clip-to-geometry = true;
      }
      {
        matches = [
          { app-id = "^firefox$"; }
          { app-id = "^zen.*$"; }
          { app-id = "^chromium.*$"; }
          { app-id = "^google-chrome.*$"; }
        ];
        default-column-width = { proportion = 0.7; };
      }
      {
        matches = [
          { app-id = "^codium.*$"; }
          { app-id = "^code.*$"; }
          { app-id = "^zed.*$"; }
          { app-id = "^jetbrains.*$"; }
        ];
        default-column-width = { proportion = 0.75; };
      }
      {
        matches = [
          { app-id = "^Alacritty$"; }
          { app-id = "^kitty$"; }
          { app-id = "^foot$"; }
        ];
        default-column-width = { proportion = 0.5; };
      }
      {
        matches = [
          { app-id = "^org.gnome.Nautilus$"; }
          { app-id = "^thunar$"; }
          { app-id = "^pcmanfm.*$"; }
        ];
        default-column-width = { proportion = 0.55; };
      }
      # Keep Meet sharing indicators out of screencasts.
      {
        matches = [{ title = "^Meet -.*$"; }];
        open-floating = true;
        open-focused = false;
        block-out-from = "screencast";
      }
      {
        matches = [{ title = "^meet.google.com is sharing your screen.$"; }];
        open-floating = true;
        open-focused = false;
      }
      {
        matches = [
          { title = "^Picture-in-Picture$"; }
          { title = "^Picture in picture$"; }
        ];
        open-floating = true;
      }
      {
        matches = [
          { app-id = "^gamescope$"; }
          { app-id = "^steam_app_.*$"; }
        ];
        open-fullscreen = true;
      }
      {
        matches = [
          { app-id = "^file-roller$"; }
          { app-id = "^org.gnome.Calculator$"; }
          { app-id = "^pavucontrol$"; }
          { app-id = "^nm-connection-editor$"; }
          { app-id = "^blueman-manager$"; }
        ];
        open-floating = true;
      }
    ];

    animations = {
      workspace-switch.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1000;
        epsilon = 0.0001;
      };
      horizontal-view-movement.kind.spring = {
        damping-ratio = 0.95;
        stiffness = 1000;
        epsilon = 0.0001;
      };
      window-movement.kind.spring = {
        damping-ratio = 0.95;
        stiffness = 1000;
        epsilon = 0.0001;
      };
      window-resize.kind.spring = {
        damping-ratio = 0.95;
        stiffness = 1000;
        epsilon = 0.0001;
      };
      config-notification-open-close.kind.spring = {
        damping-ratio = 0.6;
        stiffness = 1000;
        epsilon = 0.001;
      };
      exit-confirmation-open-close.kind.spring = {
        damping-ratio = 0.6;
        stiffness = 500;
        epsilon = 0.01;
      };
    };

    cursor = {
      size = 24;
      hide-when-typing = true;
      hide-after-inactive-ms = 10000;
    };

    hotkey-overlay.skip-at-startup = true;
    overview.zoom = 0.65;

    binds = {
      "Mod+Shift+Slash".action.show-hotkey-overlay = [];

      "Mod+Return".action.spawn = [ "alacritty" ];
      "Mod+E".action.spawn = [ "nautilus" ];
      "Mod+R".action.spawn = [ "fuzzel" ];
      "Mod+S".action.spawn = [ "fuzzel-omnibar" "--command=search" ];
      "Alt+L".action.spawn = [ "hyprlock" ];

      "Mod+N".action.spawn = [ "swaync-client" "-t" "-sw" ];
      "Mod+Shift+N".action.spawn = [ "swaync-client" "-C" ];

      "XF86AudioRaiseVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
        allow-when-locked = true;
      };
      "XF86AudioLowerVolume" = {
        action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
        allow-when-locked = true;
      };
      "XF86MonBrightnessUp" = {
        action.spawn = [ "brightnessctl" "s" "10%+" ];
        allow-when-locked = true;
      };
      "XF86MonBrightnessDown" = {
        action.spawn = [ "brightnessctl" "s" "10%-" ];
        allow-when-locked = true;
      };
      "XF86AudioMute" = {
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        allow-when-locked = true;
      };
      "XF86AudioMicMute" = {
        action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
        allow-when-locked = true;
      };

      "Mod+Q".action.close-window = [];

      "Mod+Left".action.focus-column-left = [];
      "Mod+Down".action.focus-window-down = [];
      "Mod+Up".action.focus-window-up = [];
      "Mod+Right".action.focus-column-right = [];
      "Mod+H".action.focus-column-left = [];
      "Mod+J".action.focus-window-down = [];
      "Mod+K".action.focus-window-up = [];
      "Mod+L".action.focus-column-right = [];

      "Mod+Ctrl+Left".action.move-column-left = [];
      "Mod+Ctrl+Down".action.move-window-down = [];
      "Mod+Ctrl+Up".action.move-window-up = [];
      "Mod+Ctrl+Right".action.move-column-right = [];
      "Mod+Ctrl+H".action.move-column-left = [];
      "Mod+Ctrl+J".action.move-window-down = [];
      "Mod+Ctrl+K".action.move-window-up = [];
      "Mod+Ctrl+L".action.move-column-right = [];

      "Mod+Home".action.focus-column-first = [];
      "Mod+End".action.focus-column-last = [];
      "Mod+Ctrl+Home".action.move-column-to-first = [];
      "Mod+Ctrl+End".action.move-column-to-last = [];

      "Mod+Shift+Left".action.focus-monitor-left = [];
      "Mod+Shift+Down".action.focus-monitor-down = [];
      "Mod+Shift+Up".action.focus-monitor-up = [];
      "Mod+Shift+Right".action.focus-monitor-right = [];
      "Mod+Shift+H".action.focus-monitor-left = [];
      "Mod+Shift+J".action.focus-monitor-down = [];
      "Mod+Shift+K".action.focus-monitor-up = [];
      "Mod+Shift+L".action.focus-monitor-right = [];

      "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
      "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
      "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
      "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];
      "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [];
      "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [];
      "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [];
      "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [];

      "Mod+Page_Down".action.focus-workspace-down = [];
      "Mod+Page_Up".action.focus-workspace-up = [];
      "Mod+I".action.focus-workspace-down = [];
      "Mod+U".action.focus-workspace-up = [];

      "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [];
      "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [];
      "Mod+Shift+I".action.move-column-to-workspace-down = [];
      "Mod+Shift+U".action.move-column-to-workspace-up = [];

      "Mod+Ctrl+Page_Down".action.move-workspace-down = [];
      "Mod+Ctrl+Page_Up".action.move-workspace-up = [];
      "Mod+Ctrl+I".action.move-workspace-down = [];
      "Mod+Ctrl+U".action.move-workspace-up = [];

      "Mod+WheelScrollDown" = {
        action.focus-workspace-down = [];
        cooldown-ms = 150;
      };
      "Mod+WheelScrollUp" = {
        action.focus-workspace-up = [];
        cooldown-ms = 150;
      };
      "Mod+Ctrl+WheelScrollDown" = {
        action.move-column-to-workspace-down = [];
        cooldown-ms = 150;
      };
      "Mod+Ctrl+WheelScrollUp" = {
        action.move-column-to-workspace-up = [];
        cooldown-ms = 150;
      };

      "Mod+WheelScrollRight".action.focus-column-right = [];
      "Mod+WheelScrollLeft".action.focus-column-left = [];
      "Mod+Ctrl+WheelScrollRight".action.move-column-right = [];
      "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [];
      "Mod+Shift+WheelScrollDown".action.focus-column-right = [];
      "Mod+Shift+WheelScrollUp".action.focus-column-left = [];
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [];
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [];

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+Comma".action.consume-window-into-column = [];
      "Mod+Period".action.expel-window-from-column = [];
      "Mod+BracketLeft".action.consume-or-expel-window-left = [];
      "Mod+BracketRight".action.consume-or-expel-window-right = [];

      "Mod+D".action.switch-preset-column-width = [];
      "Mod+Shift+D".action.reset-window-height = [];
      "Mod+F".action.maximize-column = [];
      "Mod+Shift+F".action.fullscreen-window = [];
      "Mod+C".action.center-column = [];

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      "Print".action.screenshot = [];
      "Ctrl+Print".action.screenshot-screen = [];
      "Alt+Print".action.screenshot-window = [];

      "Mod+Shift+E".action.quit = [];
      "Mod+Shift+P".action.power-off-monitors = [];

      # Toggle secondary monitor while gaming to prevent mouse escape.
      "Mod+Shift+M".action.spawn = [ "sh" "-c" "if [ -f /tmp/dp2-off ]; then niri msg output DP-2 on && rm /tmp/dp2-off; else niri msg output DP-2 off && touch /tmp/dp2-off; fi" ];
    };
  };

  home.packages = with pkgs; [
    niri
    xwayland-satellite
    waybar
    awww
    fuzzel
    alacritty
    brightnessctl
  ];
}
