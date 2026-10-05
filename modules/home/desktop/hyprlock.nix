{ ... }:
let
  vesper = import ../themes/vesper.nix;
  wallpaper = "${../../../assets/wallpapers/current_wallpaper.jpg}";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      # GENERAL
      general = {
        no_fade_in = false;
        no_fade_out = false;
        hide_cursor = false;
        grace = 2;
        disable_loading_bar = true;
      };

      # BACKGROUND
      background = [
        {
          monitor = "";
          path = wallpaper;
          blur_passes = 2;
          contrast = 1.0;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      # INPUT FIELD
      input-field = [
        {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.35;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(16, 16, 16, 0.8)";
          font_color = "rgb(255, 255, 255)";
          fade_on_empty = false;
          rounding = -1;
          check_color = "rgb(153, 255, 228)";
          fail_color = "rgb(255, 128, 128)";
          placeholder_text = "Password...";
          hide_input = false;
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
      ];

      # DATE
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(255, 255, 255, 0.75)";
          font_size = 22;
          font_family = "JetBrains Mono";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # TIME
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%-I:%M")"'';
          color = "rgba(255, 255, 255, 0.75)";
          font_size = 140;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
