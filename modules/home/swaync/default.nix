{ pkgs, lib, ... }:
let
  brokenPine = import ../broken-pine.nix;

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
      border: 2px solid alpha(${brokenPine.blue}, 0.5);
      background: ${brokenPine.background};
      background-color: ${brokenPine.background};
      padding: 0;
      margin: 0;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
    }

    .notification-content {
      padding: 14px 16px;
      background: ${brokenPine.background};
    }

    .notification.critical {
      border-color: ${brokenPine.red};
    }

    .notification.low {
      border-color: ${brokenPine.mutedAlt};
    }

    .summary {
      color: ${brokenPine.text};
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 4px;
    }

    .time {
      color: ${brokenPine.muted};
      font-size: 11px;
      margin-left: 12px;
    }

    .body {
      color: ${brokenPine.textAlt};
      font-size: 12px;
    }

    .notification-default-action {
      border-radius: 12px;
      margin: 0;
    }

    .notification-default-action:hover {
      background: ${brokenPine.surfaceVariant};
    }

    .close-button {
      background: ${brokenPine.surfaceActive};
      color: ${brokenPine.text};
      border-radius: 6px;
      padding: 2px 8px;
      margin: 8px;
    }

    .close-button:hover {
      background: ${brokenPine.red};
      color: ${brokenPine.background};
    }

    .notification-action {
      background: ${brokenPine.surfaceVariant};
      color: ${brokenPine.text};
      border-radius: 8px;
      padding: 6px 12px;
      margin: 6px 4px;
      border: 1px solid ${brokenPine.border};
    }

    .notification-action:hover {
      background: ${brokenPine.blue};
      color: ${brokenPine.background};
    }

    .notification-group {
      margin: 6px 12px;
    }

    .notification-group-headers {
      color: ${brokenPine.text};
      font-weight: 700;
      font-size: 13px;
      padding: 6px 12px;
    }

    .notification-group-icon {
      color: ${brokenPine.blue};
    }

    .notification-group-collapse-button {
      background: ${brokenPine.surfaceVariant};
      color: ${brokenPine.text};
      border-radius: 6px;
      padding: 4px 8px;
      margin: 4px;
    }

    .notification-group-collapse-button:hover {
      background: ${brokenPine.blue};
      color: ${brokenPine.background};
    }

    /* Control Center - sidebar only */
    .control-center {
      background: ${brokenPine.background};
      background-color: ${brokenPine.background};
      border-radius: 4px;
      border: 2px solid alpha(${brokenPine.blue}, 0.5);
      margin: 8px;
      padding: 12px 0;
    }

    .control-center-list {
      background: transparent;
    }

    .control-center-list-placeholder {
      color: ${brokenPine.mutedAlt};
      padding: 24px;
      background: transparent;
    }

    .widget-title {
      color: ${brokenPine.text};
      font-size: 16px;
      font-weight: 700;
      padding: 8px 16px;
      background: transparent;
    }

    .widget-title button {
      background: ${brokenPine.surfaceVariant};
      color: ${brokenPine.text};
      border-radius: 4px;
      padding: 6px 12px;
      border: none;
    }

    .widget-title button:hover {
      background: ${brokenPine.red};
      color: ${brokenPine.background};
    }

    .widget-dnd {
      padding: 6px 16px;
      margin: 6px 12px;
      background: transparent;
    }

    .widget-dnd > switch {
      background: ${brokenPine.surfaceActive};
      border-radius: 4px;
      padding: 2px;
    }

    .widget-dnd > switch:checked {
      background: ${brokenPine.blue};
    }

    .widget-dnd > switch slider {
      background: ${brokenPine.text};
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
