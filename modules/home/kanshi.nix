{ config, pkgs, lib, hostConfig ? "desk", ... }:

{
  services.kanshi = {
    enable = true;
    # Use graphical-session.target for more reliable startup
    systemdTarget = "graphical-session.target";

    profiles = if hostConfig == "desk" then {
      # Dual monitor configuration
      desk-dual = {
        outputs = [
          {
            criteria = "Acer Technologies XB241YU #ASOV6yMzDgvd";
            mode = "2560x1440@165.000Hz";
            position = "-2560,0";
            scale = 1.0;
          }
          {
            criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
            mode = "2560x1440@169.831Hz";
            position = "0,0";
            scale = 1.0;
          }
        ];
      };

      # Fallback single monitor profiles
      desk-single-acer = {
        outputs = [
          {
            criteria = "Acer Technologies XB241YU #ASOV6yMzDgvd";
            mode = "2560x1440@165.000Hz";
            position = "0,0";
            scale = 1.0;
          }
        ];
      };

      desk-single-gigabyte = {
        outputs = [
          {
            criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
            mode = "2560x1440@169.831Hz";
            position = "0,0";
            scale = 1.0;
          }
        ];
      };
    } else {
      # Notebook profiles
      book-internal = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "2880x1800@120.000Hz";
            position = "0,0";
            scale = 1.55;
          }
        ];
      };

      book-home-gigabyte = {
        outputs = [
          {
            criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
            # mode = "2560x1440@169.831Hz";
            mode = "2560x1440@60Hz";
            position = "0,-1440";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2880x1800@120.000Hz";
            position = "0,0";
            scale = 1.55;
          }
        ];
      };

      book-with-work-monitor-desk-1 = {
        outputs = [
          {
            criteria = "Samsung Electric Company LF24T450F HX5T901856";
            mode = "1920x1080@75.000Hz";
            position = "0,-1080";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2880x1800@120.000Hz";
            position = "0,0";
            scale = 1.55;
          }
        ];
      };

      book-with-work-monitor-desk-2 = {
        outputs = [
          {
            criteria = "Samsung Electric Company LF24T450F HX5W500259";
            mode = "1920x1080@75.000Hz";
            position = "0,-1080";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            mode = "2880x1800@120.000Hz";
            position = "0,0";
            scale = 1.55;
          }
        ];
      };

      book-with-tv = {
        outputs = [
          {
            criteria = "Samsung Electric Company SAMSUNG 0x01000E00";
            mode = "3840x2160@60.000Hz";
            position = "0,-2160";
            scale = 2.0;
          }
          {
            criteria = "eDP-1";
            mode = "2880x1800@120.000Hz";
            position = "0,0";
            scale = 1.55;
          }
        ];
      };
    };
  };

  home.packages = with pkgs; [
    kanshi
  ];
}
