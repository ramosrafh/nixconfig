{ ... }:
let
  # Wallpaper shared by every kanshi profile. The path is relative to this
  # file so it resolves the same regardless of which host imports it.
  wallpaper = "${../assets/wallpapers/current_wallpaper.jpg}";
  wallpaperCmd = "awww img ${wallpaper}";
in
{
  inherit wallpaper wallpaperCmd;

  # Build a kanshi profile that restores the wallpaper after the outputs
  # settle. `name` is the profile name and `outputs` the list of displays.
  mkProfile = name: outputs: {
    profile = {
      inherit name outputs;
      exec = [ "sleep 0.5 && ${wallpaperCmd}" ];
    };
  };
}
