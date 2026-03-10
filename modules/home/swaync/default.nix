{ pkgs, lib, ... }:
let
  # Catppuccin Mocha colors
  catppuccin = {
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
    surface0 = "#313244";
    surface1 = "#45475a";
    surface2 = "#585b70";
    overlay0 = "#6c7086";
    overlay1 = "#7f849c";
    overlay2 = "#9399b2";
    text = "#cdd6f4";
    subtext0 = "#a6adc8";
    subtext1 = "#bac2de";
    lavender = "#b4befe";
    blue = "#89b4fa";
    sapphire = "#74c7ec";
    sky = "#89dceb";
    teal = "#94e2d5";
    green = "#a6e3a1";
    yellow = "#f9e2af";
    peach = "#fab387";
    maroon = "#eba0ac";
    red = "#f38ba8";
    mauve = "#cba6f7";
    pink = "#f5c2e7";
    flamingo = "#f2cdcd";
    rosewater = "#f5e0dc";
  };

  swaync-style = ''
    /* ===== CRITICAL: Window backgrounds must be transparent ===== */

    /* GTK4 window widgets - these are the actual windows */
    notificationwindow,
    blankwindow {
      background: transparent;
    }

    /* The blank window behind control center on all monitors */
    .blank-window {
      background: transparent;
    }

    /* Floating notifications - popup container */
    .floating-notifications {
      background: transparent;
    }

    /* ===== NOTIFICATION STYLING ===== */

    * {
      font-family: "Inter", "Font Awesome 6 Free";
      font-size: 13px;
      font-weight: 500;
    }

    /* Individual notification row */
    .notification-row {
      outline: none;
      margin: 6px 12px;
      padding: 0;
      background: transparent;
    }

    .notification-row:focus,
    .notification-row:hover {
      background: transparent;
    }

    /* The actual notification box */
    .notification {
      border-radius: 4px;
      border: 2px solid alpha(${catppuccin.mauve}, 0.5);
      background: ${catppuccin.base};
      background-color: ${catppuccin.base};
      padding: 0;
      margin: 0;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
    }

    .notification-content {
      padding: 14px 16px;
      background: ${catppuccin.base};
    }

    .notification.critical {
      border-color: ${catppuccin.red};
    }

    .notification.low {
      border-color: ${catppuccin.overlay0};
    }

    .summary {
      color: ${catppuccin.text};
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 4px;
    }

    .time {
      color: ${catppuccin.overlay1};
      font-size: 11px;
      margin-left: 12px;
    }

    .body {
      color: ${catppuccin.subtext1};
      font-size: 12px;
    }

    .notification-default-action {
      border-radius: 12px;
      margin: 0;
    }

    .notification-default-action:hover {
      background: ${catppuccin.surface0};
    }

    .close-button {
      background: ${catppuccin.surface1};
      color: ${catppuccin.text};
      border-radius: 6px;
      padding: 2px 8px;
      margin: 8px;
    }

    .close-button:hover {
      background: ${catppuccin.red};
      color: ${catppuccin.base};
    }

    .notification-action {
      background: ${catppuccin.surface0};
      color: ${catppuccin.text};
      border-radius: 8px;
      padding: 6px 12px;
      margin: 6px 4px;
      border: 1px solid ${catppuccin.surface1};
    }

    .notification-action:hover {
      background: ${catppuccin.mauve};
      color: ${catppuccin.base};
    }

    .notification-group {
      margin: 6px 12px;
    }

    .notification-group-headers {
      color: ${catppuccin.text};
      font-weight: 700;
      font-size: 13px;
      padding: 6px 12px;
    }

    .notification-group-icon {
      color: ${catppuccin.mauve};
    }

    .notification-group-collapse-button {
      background: ${catppuccin.surface0};
      color: ${catppuccin.text};
      border-radius: 6px;
      padding: 4px 8px;
      margin: 4px;
    }

    .notification-group-collapse-button:hover {
      background: ${catppuccin.mauve};
      color: ${catppuccin.base};
    }

    /* Control Center - sidebar only */
    .control-center {
      background: ${catppuccin.base};
      background-color: ${catppuccin.base};
      border-radius: 4px;
      border: 2px solid alpha(${catppuccin.mauve}, 0.5);
      margin: 8px;
      padding: 12px 0;
    }

    .control-center-list {
      background: transparent;
    }

    .control-center-list-placeholder {
      color: ${catppuccin.overlay0};
      padding: 24px;
      background: transparent;
    }

    .widget-title {
      color: ${catppuccin.text};
      font-size: 16px;
      font-weight: 700;
      padding: 8px 16px;
      background: transparent;
    }

    .widget-title button {
      background: ${catppuccin.surface0};
      color: ${catppuccin.text};
      border-radius: 4px;
      padding: 6px 12px;
      border: none;
    }

    .widget-title button:hover {
      background: ${catppuccin.red};
      color: ${catppuccin.base};
    }

    .widget-dnd {
      padding: 6px 16px;
      margin: 6px 12px;
      background: transparent;
    }

    .widget-dnd > switch {
      background: ${catppuccin.surface1};
      border-radius: 4px;
      padding: 2px;
    }

    .widget-dnd > switch:checked {
      background: ${catppuccin.mauve};
    }

    .widget-dnd > switch slider {
      background: ${catppuccin.text};
      border-radius: 4px;
      min-width: 18px;
      min-height: 18px;
    }

  '';

  swaync-config = {
    "$schema" = "/etc/xdg/swaync/configSchema.json";
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "overlay";
    layer-shell = true;
    cssPriority = "user";

    # Disable the background overlay completely
    control-center-exclusive-zone = true;

    # This prevents the gray overlay background
    fit-to-screen = false;

    # Notification display settings
    notification-window-width = 400;
    notification-icon-size = 56;
    notification-body-image-height = 120;
    notification-body-image-width = 200;

    # Timeout settings
    timeout = 6;
    timeout-low = 4;
    timeout-critical = 0;

    # Limit notification popup rate to prevent spam after suspend
    # Max 5 popups visible at once, notifications still go to history
    notification-inline-replies = false;

    # Only make specific notifications transient (not stored in history)
    # DO NOT use app-name = ".*" as it makes ALL notifications transient!
    notification-visibility = {};

    # Control center settings
    control-center-width = 420;
    control-center-height = 800;
    control-center-margin-top = 12;
    control-center-margin-bottom = 12;
    control-center-margin-right = 12;

    # Notification grouping - KEY FOR REDUCING SPAM
    notification-2fa-action = true;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = false;

    # Widgets in control center
    widgets = [
      "title"
      "dnd"
      "notifications"
    ];

    widget-config = {
      title = {
        text = "Notificações";
        clear-all-button = true;
        button-text = "Limpar";
      };
      dnd = {
        text = "Não perturbe";
      };
    };
  };

  # Script to manage notifications after suspend
  notification-resume-script = pkgs.writeShellScript "notification-resume" ''
    #!/usr/bin/env bash
    # Wait for system to stabilize after resume
    sleep 3

    # Enable Do Not Disturb temporarily to prevent popup spam
    swaync-client --dnd-on 2>/dev/null || true

    # Wait a bit more for any pending notifications to arrive
    sleep 2

    # Get notification count
    COUNT=$(swaync-client --count 2>/dev/null || echo "0")

    if [ "$COUNT" -gt 5 ]; then
      # Close all popup notifications (they're still in history)
      swaync-client --close-all 2>/dev/null || true

      # Show a single summary notification
      notify-send -u low -t 10000 "📬 $COUNT notificações pendentes" \
        "Abra o centro de notificações para ver todas." \
        -h string:x-canonical-private-synchronous:resume-summary

      # Disable DND and open panel after brief delay
      sleep 1
      swaync-client --dnd-off 2>/dev/null || true
      swaync-client --open-panel 2>/dev/null || true
    else
      # Few notifications, just disable DND
      swaync-client --dnd-off 2>/dev/null || true
    fi
  '';
in {
  services.swaync = {
    enable = true;
    settings = swaync-config;
    style = swaync-style;
  };

  home.packages = with pkgs; [
    swaynotificationcenter
    libnotify
  ];

  # Systemd service to handle resume from suspend
  # Note: User services can't directly use suspend.target, so we use a path-based trigger
  systemd.user.services.notification-resume = {
    Unit = {
      Description = "Handle notifications after resume from suspend";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${notification-resume-script}";
      # Ensure swaync is running
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
    };
  };

  # Use a system-level sleep hook to trigger the user service
  # This file will be symlinked via home.file
  home.file.".local/bin/notification-resume-trigger" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Triggered by system sleep hook, runs the user service
      if [ "$1" = "post" ]; then
        sleep 2
        systemctl --user start notification-resume.service || true
      fi
    '';
  };
}
