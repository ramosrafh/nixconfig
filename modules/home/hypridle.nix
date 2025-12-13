{ pkgs, ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprlock}/bin/hyprlock";
        ignore_dbus_inhibit = false;
      };

      listener = [
        # Lock after 10 minutes of inactivity
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        # Turn off displays after 15 minutes
        {
          timeout = 900;
          on-timeout = "${pkgs.niri-unstable}/bin/niri msg action power-off-monitors";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    hypridle
  ];
}
