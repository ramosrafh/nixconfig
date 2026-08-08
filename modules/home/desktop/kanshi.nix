{ hostConfig ? "desk", ... }:

let
  wallpaper = "${../../../assets/wallpapers/current_wallpaper.jpg}";
  wallpaperCmd = "awww img ${wallpaper}";

  mkProfile = name: outputs: {
    profile = {
      inherit name outputs;
      exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    };
  };

  acer = position: {
    criteria = "Acer Technologies XB241YU #ASOV6yMzDgvd";
    mode = "2560x1440@165.000Hz";
    inherit position;
    scale = 1.0;
  };

  gigabyte = position: {
    criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266";
    mode = "2560x1440@169.831Hz";
    inherit position;
    scale = 1.0;
  };

  bookInternal = {
    criteria = "eDP-1";
    mode = "2880x1800@120.000Hz";
    position = "0,0";
    scale = 1.45;
  };

  workMonitor = criteria: mode: {
    inherit criteria mode;
    position = "0,-1080";
    scale = 1.0;
  };

  deskProfiles = [
    (mkProfile "desk-dual" [
      (acer "2560,0")
      (gigabyte "0,0")
    ])
    (mkProfile "desk-single-acer" [ (acer "0,0") ])
    (mkProfile "desk-single-gigabyte" [ (gigabyte "0,0") ])
  ];

  bookProfiles = [
    (mkProfile "book-internal" [ bookInternal ])
    (mkProfile "book-home-gigabyte" [
      (gigabyte "0,-1440")
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
    # Fallback: unknown external monitor on top, notebook below.
    (mkProfile "book-unknown-monitor" [
      {
        criteria = "*";
        position = "0,-1080";
        scale = 1.0;
      }
      bookInternal
    ])
  ];
in
{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = if hostConfig == "desk" then deskProfiles else bookProfiles;
  };
}
