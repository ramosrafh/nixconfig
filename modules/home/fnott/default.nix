{ pkgs, ... }: {
  services.fnott = {
    enable = true;

    settings = {
      main = {
        notification-margin = 5;

        # Catppuccin Mocha colors
        background = "1e1e2eff";
        title-font = "Inter:size=12:weight=bold";
        title-color = "cdd6f4ff";
        summary-font = "Inter:size=11";
        summary-color = "bac2deff";
        body-font = "Inter:size=10";
        body-color = "a6adc8ff";

        border-size = 2;
        border-color = "89b4faff";
        border-radius = 8;

        padding-horizontal = 15;
        padding-vertical = 10;

        max-timeout = 5;
        default-timeout = 3;

        # Position
        anchor = "top-right";

        # Icon settings
        max-icon-size = 48;
      };

      low = {
        background = "1e1e2eff";
        border-color = "89b4faff";
        title-color = "cdd6f4ff";
        summary-color = "bac2deff";
        body-color = "a6adc8ff";
      };

      normal = {
        background = "1e1e2eff";
        border-color = "89b4faff";
        title-color = "cdd6f4ff";
        summary-color = "bac2deff";
        body-color = "a6adc8ff";
      };

      critical = {
        background = "1e1e2eff";
        border-color = "f38ba8ff";
        title-color = "f38ba8ff";
        summary-color = "cdd6f4ff";
        body-color = "bac2deff";
        default-timeout = 0;
      };
    };
  };

  home.packages = with pkgs; [
    fnott
    libnotify # for notify-send command
  ];
}
