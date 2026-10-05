{ ... }:
let
  wallpaper = "${../../assets/wallpapers/current_wallpaper.jpg}";
  wallpaperCmd = "awww img ${wallpaper}";

  mkProfile = name: outputs: {
    profile = {
      inherit name outputs;
      exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    };
  };
  bookInternal = {
    criteria = "eDP-1";
    mode = "2880x1800@120.000Hz";
    position = "0,0";
    scale = 1.45;
  };
  gigabyte = {
    criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
    mode = "2560x1440@169.831Hz";
    position = "0,-1440";
    scale = 1.0;
  };
  workMonitor = criteria: mode: {
    inherit criteria mode;
    position = "0,-1080";
    scale = 1.0;
  };
in
{
  imports = [ ../../modules/home/profiles/desktop.nix ];

  programs.niri.settings.input.power-key-handling.enable = false;
  services.kanshi.settings = [
    (mkProfile "book-internal" [ bookInternal ])
    (mkProfile "book-home-gigabyte" [
      gigabyte
      bookInternal
    ])
    (mkProfile "book-with-work-monitor-desk-1" [
      (workMonitor "Samsung Electric Company LF24T450F HX5T901856" "1920x1080@75.000Hz")
      bookInternal
    ])
    (mkProfile "book-with-work-monitor-desk-2" [
      (workMonitor "Samsung Electric Company LF24T450F HX5W500259" "1920x1080@75.000Hz")
      bookInternal
    ])
    (mkProfile "book-with-work-monitor-desk-3" [
      (workMonitor "Samsung Electric Company LF24T450F HX5W500497" "1920x1080@60.000Hz")
      bookInternal
    ])
    (mkProfile "book-with-tv" [
      {
        criteria = "Samsung Electric Company SAMSUNG 0x01000E00";
        mode = "3840x2160@60.000Hz";
        position = "0,-2160";
        scale = 2.0;
      }
      bookInternal
    ])
    (mkProfile "book-unknown-monitor" [
      {
        criteria = "*";
        position = "0,-1080";
        scale = 1.0;
      }
      bookInternal
    ])
  ];
}
