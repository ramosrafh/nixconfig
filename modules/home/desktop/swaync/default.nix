{ ... }:
let
  vesper = import ../../themes/vesper.nix;

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
      margin: 6px 20px 6px 12px;
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
      border: 2px solid ${vesper.yellow};
      background: ${vesper.background};
      background-color: ${vesper.background};
      padding: 0;
      margin: 0;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
    }

    .notification-content {
      padding: 14px 16px;
      background: ${vesper.background};
    }

    .notification.critical {
      border-color: ${vesper.red};
    }

    .notification.low {
      border-color: ${vesper.mutedAlt};
    }

    .summary {
      color: ${vesper.text};
      font-size: 14px;
      font-weight: 700;
      margin-bottom: 4px;
    }

    .time {
      color: ${vesper.muted};
      font-size: 11px;
      margin-left: 12px;
    }

    .body {
      color: ${vesper.textAlt};
      font-size: 12px;
    }

    .notification-default-action {
      border-radius: 12px;
      margin: 0;
    }

    .notification-default-action:hover {
      background: ${vesper.surfaceVariant};
    }

    .close-button {
      background: ${vesper.surfaceActive};
      color: ${vesper.text};
      border-radius: 6px;
      padding: 2px 8px;
      margin: 8px;
    }

    .close-button:hover {
      background: ${vesper.red};
      color: ${vesper.background};
    }

    .notification-action {
      background: ${vesper.surfaceVariant};
      color: ${vesper.text};
      border-radius: 8px;
      padding: 6px 12px;
      margin: 6px 4px;
      border: 1px solid ${vesper.border};
    }

    .notification-action:hover {
      background: ${vesper.blue};
      color: ${vesper.background};
    }

    .notification-group {
      margin: 6px 12px;
    }

    .notification-group-headers {
      color: ${vesper.text};
      font-weight: 700;
      font-size: 13px;
      padding: 6px 12px;
    }

    .notification-group-icon {
      color: ${vesper.blue};
    }

    .notification-group-collapse-button {
      background: ${vesper.surfaceVariant};
      color: ${vesper.text};
      border-radius: 6px;
      padding: 4px 8px;
      margin: 4px;
    }

    .notification-group-collapse-button:hover {
      background: ${vesper.blue};
      color: ${vesper.background};
    }

    /* Control Center - sidebar only */
    .control-center {
      background: ${vesper.background};
      background-color: ${vesper.background};
      border-radius: 4px;
      border: 2px solid alpha(${vesper.blue}, 0.5);
      margin: 8px;
      padding: 12px 0;
    }

    .control-center-list {
      background: transparent;
    }

    .control-center-list-placeholder {
      color: ${vesper.mutedAlt};
      padding: 24px;
      background: transparent;
    }

    .widget-title {
      color: ${vesper.text};
      font-size: 16px;
      font-weight: 700;
      padding: 8px 16px;
      background: transparent;
    }

    .widget-title button {
      background: ${vesper.surfaceVariant};
      color: ${vesper.text};
      border-radius: 4px;
      padding: 6px 12px;
      border: none;
    }

    .widget-title button:hover {
      background: ${vesper.red};
      color: ${vesper.background};
    }

    .widget-dnd {
      padding: 6px 16px;
      margin: 6px 12px;
      background: transparent;
    }

    .widget-dnd > switch {
      background: ${vesper.surfaceActive};
      border-radius: 4px;
      padding: 2px;
    }

    .widget-dnd > switch:checked {
      background: ${vesper.blue};
    }

    .widget-dnd > switch slider {
      background: ${vesper.text};
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
    notification-visibility = { };

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

in
{
  services.swaync = {
    enable = true;
    settings = swaync-config;
    style = swaync-style;
  };
}
