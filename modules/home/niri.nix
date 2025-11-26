{ config, pkgs, ... }:
let
  wallpaper = "${../../assets/wallpapers/current_wallpaper.jpg}";
in {
  programs.niri = {
    settings = {
      # Output configuration

      outputs = {
        "eDP-1" = {
          mode = {
            width=2880;
            height=1800;
            refresh = 120.0;
          };
          scale = 1.5;
        };
        # Primary Acer monitor (left) - current EDID
        "Acer Technologies XB241YU #ASOV6yMzDgvd" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 165.0;
          };
          position = {
            x = -2560;
            y = 0;
          };
          scale = 1.0;
        };
        # Secondary monitor (right/main) - current EDID
        "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 169.831;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.0;
        };
      };

      # Input configuration
      input = {
        focus-follows-mouse = {
          enable = false;
        };
        mouse = {
          accel-speed = 0.15;
        };
        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = false;
        };
        keyboard = {
          xkb = {
            layout = "br";
            # layout = "us";
            # variant "intl"/
            options = "grp:alt_space_toggle,caps:swapescape,altwin:swap_lalt_lwin";
          };
        };
      };

      # Layout configuration
      layout = {
        gaps = 14;
        center-focused-column = "never";
        background-color = "transparent";

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = {};

        focus-ring = {
          width = 1.5;
          active.color = "#919191";
          inactive.color = "#665c54";
        };

        border = {
          enable = false;
        };
      };

      # Spawn at startup
      spawn-at-startup = [
        { command = ["swaybg" "-m" "fill" "-i" wallpaper]; }
        { command = ["sh" "-c" "sleep 1.0 && waybar"]; }
      ];

      # Layer rules for wallpaper
      layer-rules = [
        {
          matches = [{ namespace = "^wallpaper$"; }];
          place-within-backdrop = true;
        }
      ];

      prefer-no-csd = true;

      screenshot-path = "~/Pictures/screenshots/%Y-%m-%d %H-%M-%S.png";

      # Window rules
      window-rules = [
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
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];

      # Animations
      animations = {
        workspace-switch.kind = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };

        horizontal-view-movement.kind = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };

        window-movement.kind = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };

        window-resize.kind = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };

        config-notification-open-close.kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };

        exit-confirmation-open-close.kind = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 500;
            epsilon = 0.01;
          };
        };
      };

      # Cursor configuration
      cursor = {
        size = 24;
        hide-when-typing = true;
        hide-after-inactive-ms = 10000;
      };

      # Hotkey overlay configuration
      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Overview configuration
      overview = {
        zoom = 0.65;
      };

      # Keybindings - using raw action syntax throughout
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = [];

        # Application launchers
        "Mod+Return".action.spawn = ["alacritty"];
        "Mod+E".action.spawn = ["nautilus"];
        "Mod+R".action.spawn = ["fuzzel"];
        "Mod+S".action.spawn = ["fuzzel-omnibar" "--command=search"];
        "Super+Alt+L".action.spawn = ["swaylock"];

        # Media keys
        "XF86AudioRaiseVolume" = {
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action.spawn = ["brightnessctl" "s" "10%+"];
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = ["brightnessctl" "s" "10%-"];
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          allow-when-locked = true;
        };

        # Window management
        "Mod+Q".action.close-window = [];

        # Focus navigation (arrows)
        "Mod+Left".action.focus-column-left = [];
        "Mod+Down".action.focus-window-down = [];
        "Mod+Up".action.focus-window-up = [];
        "Mod+Right".action.focus-column-right = [];

        # Focus navigation (vim keys)
        "Mod+H".action.focus-column-left = [];
        "Mod+J".action.focus-window-down = [];
        "Mod+K".action.focus-window-up = [];
        "Mod+L".action.focus-column-right = [];

        # Move windows (arrows)
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Down".action.move-window-down = [];
        "Mod+Ctrl+Up".action.move-window-up = [];
        "Mod+Ctrl+Right".action.move-column-right = [];

        # Move windows (vim keys)
        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+J".action.move-window-down = [];
        "Mod+Ctrl+K".action.move-window-up = [];
        "Mod+Ctrl+L".action.move-column-right = [];

        # Focus first/last column
        "Mod+Home".action.focus-column-first = [];
        "Mod+End".action.focus-column-last = [];
        "Mod+Ctrl+Home".action.move-column-to-first = [];
        "Mod+Ctrl+End".action.move-column-to-last = [];

        # Focus monitor
        "Mod+Shift+Left".action.focus-monitor-left = [];
        "Mod+Shift+Down".action.focus-monitor-down = [];
        "Mod+Shift+Up".action.focus-monitor-up = [];
        "Mod+Shift+Right".action.focus-monitor-right = [];
        "Mod+Shift+H".action.focus-monitor-left = [];
        "Mod+Shift+J".action.focus-monitor-down = [];
        "Mod+Shift+K".action.focus-monitor-up = [];
        "Mod+Shift+L".action.focus-monitor-right = [];

        # Move to monitor
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [];

        # Workspace navigation
        "Mod+Page_Down".action.focus-workspace-down = [];
        "Mod+Page_Up".action.focus-workspace-up = [];
        "Mod+U".action.focus-workspace-down = [];
        "Mod+I".action.focus-workspace-up = [];

        "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [];
        "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [];
        "Mod+Shift+U".action.move-column-to-workspace-down = [];
        "Mod+Shift+I".action.move-column-to-workspace-up = [];

        "Mod+Ctrl+Page_Down".action.move-workspace-down = [];
        "Mod+Ctrl+Page_Up".action.move-workspace-up = [];
        "Mod+Ctrl+U".action.move-workspace-down = [];
        "Mod+Ctrl+I".action.move-workspace-up = [];

        # Mouse wheel
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

        # Workspace numbers
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

        # Column management
        "Mod+Comma".action.consume-window-into-column = [];
        "Mod+Period".action.expel-window-from-column = [];
        "Mod+BracketLeft".action.consume-or-expel-window-left = [];
        "Mod+BracketRight".action.consume-or-expel-window-right = [];

        # Window sizing
        "Mod+D".action.switch-preset-column-width = [];
        "Mod+Shift+D".action.reset-window-height = [];
        "Mod+F".action.maximize-column = [];
        "Mod+Shift+F".action.fullscreen-window = [];
        "Mod+C".action.center-column = [];

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Screenshots
        "Print".action.screenshot = [];
        "Ctrl+Print".action.screenshot-screen = [];
        "Alt+Print".action.screenshot-window = [];

        # System
        "Mod+Shift+E".action.quit = [];
        "Mod+Shift+P".action.power-off-monitors = [];
      };
    };
  };

  home.packages = with pkgs; [
    niri
    xwayland-satellite
    waybar
    swaybg
    fuzzel
    alacritty
    swaylock
    brightnessctl
  ];
}
