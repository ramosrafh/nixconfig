{ pkgs, ... }: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "";
        after_sleep_cmd = "";
        ignore_dbus_inhibit = false;
      };

      # Timeouts disabled - change values to enable
      # Example: 600 = 10 minutes, 900 = 15 minutes
      listener = [];
    };
  };

  home.packages = with pkgs; [
    hypridle
  ];
}
