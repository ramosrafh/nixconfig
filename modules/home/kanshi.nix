{ config, pkgs, lib, hostConfig ? "desk", ... }:

let
  wallpaper = "${../../assets/wallpapers/current_wallpaper.jpg}";
  # Command to re-apply wallpaper on all outputs
  wallpaperCmd = "awww img ${wallpaper}";
in
{
  services.kanshi = {
    enable = true;
    # Use graphical-session.target for more reliable startup
    systemdTarget = "graphical-session.target";

    settings = if hostConfig == "desk" then [{
      profile.name = "desk-dual";
      profile.outputs = [
        {
          criteria = "Acer Technologies XB241YU #ASOV6yMzDgvd";
          mode = "2560x1440@165.000Hz";
          position = "2560,0";
          scale = 1.0;
        }
        {
          criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
          mode = "2560x1440@169.831Hz";
          position = "0,0";
          scale = 1.0;
        }
      ];
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "desk-single-acer";
      profile.outputs = [
        {
          criteria = "Acer Technologies XB241YU #ASOV6yMzDgvd";
          mode = "2560x1440@165.000Hz";
          position = "0,0";
          scale = 1.0;
        }
      ];
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "desk-single-gigabyte";
      profile.outputs = [
        {
          criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
          mode = "2560x1440@169.831Hz";
          position = "0,0";
          scale = 1.0;
        }
      ];
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    }] else [{
      profile.name = "book-internal";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "2880x1800@120.000Hz";
          position = "0,0";
          scale = 1.55;
        }
      ];
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "book-home-gigabyte";
      profile.outputs = [
        {
          criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
          mode = "2560x1440@169.831Hz";
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "book-with-work-monitor-desk-1";
      profile.outputs = [
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "book-with-work-monitor-desk-2";
      profile.outputs = [
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "book-with-work-monitor-desk-3";
      profile.outputs = [
        {
          criteria = "Samsung Electric Company LF24T450F HX5W500497";
          mode = "1920x1080@60.000Hz";
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      profile.name = "book-with-tv";
      profile.outputs = [
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    } {
      # Fallback: unknown external monitor on top, notebook below
      profile.name = "book-unknown-monitor";
      profile.outputs = [
        {
          criteria = "*";
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
      profile.exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    }];

  };

  home.packages = with pkgs; [
    kanshi
  ];
}
