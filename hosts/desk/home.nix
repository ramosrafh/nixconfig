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
in
{
  imports = [
    ../../modules/home/profiles/desktop.nix
    ./wireplumber.nix
  ];

  services.kanshi.settings = [
    (mkProfile "desk-dual" [
      (acer "2560,0")
      (gigabyte "0,0")
    ])
    (mkProfile "desk-single-acer" [ (acer "0,0") ])
    (mkProfile "desk-single-gigabyte" [ (gigabyte "0,0") ])
  ];
}
