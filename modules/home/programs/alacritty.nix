{ pkgs, ... }:
let
  vesper = import ../themes/vesper.nix;
in
{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 18;
    };
    settings = {
      background = vesper.background;
      foreground = vesper.text;
      cursor = vesper.yellow;
      cursor_text_color = vesper.background;
      selection_background = vesper.surfaceActive;
      selection_foreground = vesper.text;
      color0 = vesper.background;
      color1 = vesper.red;
      color2 = vesper.green;
      color3 = vesper.yellow;
      color4 = vesper.blue;
      color5 = vesper.magenta;
      color6 = vesper.cyan;
      color7 = vesper.text;
      color8 = vesper.surfaceActive;
      color9 = vesper.red;
      color10 = vesper.green;
      color11 = vesper.yellow;
      color12 = vesper.blue;
      color13 = vesper.magenta;
      color14 = vesper.cyan;
      color15 = vesper.text;
      confirm_os_window_close = 0;
    };
  };
}
