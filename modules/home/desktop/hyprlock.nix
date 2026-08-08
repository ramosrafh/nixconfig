{ ... }:
let
  brokenPine = import ../themes/broken-pine.nix;
  wallpaper = "${../../../assets/wallpapers/current_wallpaper.jpg}";
in {
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
      background = [{
        monitor = "";
        path = wallpaper;
        blur_passes = 2;
        contrast = 1.0;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      }];

      # INPUT FIELD
      input-field = [{
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.35;
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(17, 18, 21, 0.4)";
        font_color = "rgb(215, 215, 255)";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(92, 193, 163)";
        fail_color = "rgb(234, 110, 146)";
        placeholder_text = "Password...";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      }];

      # DATE
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(215, 215, 255, 0.75)";
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
          color = "rgba(215, 215, 255, 0.75)";
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
