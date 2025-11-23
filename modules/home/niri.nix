{ config, pkgs, inputs, ... }: {
  programs.niri = {
    settings = {
      # Output configuration for desk setup
      outputs = {
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
        "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 170.0;
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
        focus-follows-mouse = true;
        
        mouse = {
          accel-speed = 0.15;
        };

        touchpad = {
          tap = true;
          dwt = true;
        };

        keyboard = {
          xkb = {
            layout = "br";
            options = "grp:alt_space_toggle,caps:swapescape,altwin:swap_lalt_lwin";
          };
        };
      };

      # Layout configuration
      layout = {
        gaps = 14;
        center-focused-column = "never";
        
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = {};

        focus-ring = {
          enable = true;
          width = 1.5;
          active-color = "#919191";
          inactive-color = "#665c54";
        };

        border = {
          enable = false;
        };

        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        background-color = "transparent";
      };

      # Layer rules
      layer-rules = [
        {
          match.namespace = "^wallpaper$";
          place-within-backdrop = true;
        }
      ];

      # Spawn at startup
      spawn-at-startup = [
        { command = ["swww-daemon"]; }
        { command = ["sh" "-c" "sleep 0.5 && swww img ~/.wallpapers/current_wallpaper.jpg"]; }
        { command = ["waybar"]; }
      ];

      # Hotkey overlay
      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Prefer no CSD
      prefer-no-csd = true;

      # Screenshot path
      screenshot-path = "~/Pictures/screenshots/%Y-%m-%d %H-%M-%S.png";

      # Window rules
      window-rules = [
        {
          matches = [{ title = "^Meet -.*$"; }];
          open-floating = true;
          default-floating-position = {
            x = 50;
            y = 50;
            relative-to = "top-right";
          };
          open-focused = false;
          block-out-from = "screencast";
        }
        {
          matches = [{ title = "^meet.google.com is sharing your screen.$"; }];
          open-floating = true;
          open-focused = false;
          default-floating-position = {
            x = 50;
            y = 50;
            relative-to = "bottom-right";
          };
        }
      ];

      # Animations
      animations = {
        workspace-switch = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        window-open = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
        window-close = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
        horizontal-view-movement = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        window-movement = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        window-resize = {
          spring = {
            damping-ratio = 0.95;
            stiffness = 1000;
            epsilon = 0.0001;
          };
        };
        config-notification-open-close = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
        };
        exit-confirmation-open-close = {
          spring = {
            damping-ratio = 0.6;
            stiffness = 500;
            epsilon = 0.01;
          };
        };
        screenshot-ui-open = {
          duration-ms = 200;
          curve = "ease-out-quad";
        };
        overview-open-close = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
      };

      # Overview configuration
      overview = {
        zoom = 0.65;
        workspace-shadow = {
          enable = false;
        };
      };

      # Cursor configuration
      cursor = {
        hide-when-typing = true;
        hide-after-inactive-ms = 10000;
      };

      # Keybindings
      binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Return".action = spawn "alacritty";
        "Mod+R".action = spawn "fuzzel";
        "Mod+S".action = spawn "fuzzel-omnibar" "--command=search";
        "Super+Alt+L".action = spawn "/bin/swaylock";

        "XF86AudioRaiseVolume" = {
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action = spawn "brightnessctl" "s" "10%+";
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = spawn "brightnessctl" "s" "10%-";
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
          allow-when-locked = true;
        };

        "Mod+Q".action = close-window;
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Ctrl+Left".action = move-column-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right;
        "Mod+Ctrl+H".action = move-column-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right;
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Shift+Page_Down".action = move-column-to-workspace-down;
        "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
        "Mod+Shift+U".action = move-column-to-workspace-down;
        "Mod+Shift+I".action = move-column-to-workspace-up;
        "Mod+Ctrl+Page_Down".action = move-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-workspace-up;
        "Mod+Ctrl+U".action = move-workspace-down;
        "Mod+Ctrl+I".action = move-workspace-up;

        "Mod+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          action = move-column-to-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          action = move-column-to-workspace-up;
          cooldown-ms = 150;
        };

        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+WheelScrollLeft".action = focus-column-left;
        "Mod+Ctrl+WheelScrollRight".action = move-column-right;
        "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
        "Mod+Shift+WheelScrollDown".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;
        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;
        "Mod+Shift+6".action = move-column-to-workspace 6;
        "Mod+Shift+7".action = move-column-to-workspace 7;
        "Mod+Shift+8".action = move-column-to-workspace 8;
        "Mod+Shift+9".action = move-column-to-workspace 9;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+D".action = switch-preset-column-width;
        "Mod+Shift+D".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
      };
    };
  };
}
