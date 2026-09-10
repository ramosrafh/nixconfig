{ pkgs, ... }:
let
  brokenPine = import ../themes/broken-pine.nix;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 20.0;
      };
      colors = {
        primary = {
          background = brokenPine.background;
          foreground = brokenPine.textAlt;
        };
        cursor = {
          text = brokenPine.background;
          cursor = brokenPine.blue;
        };
        selection = {
          text = brokenPine.text;
          background = brokenPine.surfaceActive;
        };
        normal = {
          black = brokenPine.background;
          red = brokenPine.red;
          green = brokenPine.green;
          yellow = brokenPine.yellow;
          blue = brokenPine.blue;
          magenta = brokenPine.magenta;
          cyan = brokenPine.cyan;
          white = brokenPine.textAlt;
        };
        bright = {
          black = brokenPine.surfaceActive;
          red = "#7e3647";
          green = "#31614f";
          yellow = "#8a643a";
          blue = "#566b70";
          magenta = "#4c3b47";
          cyan = "#203a46";
          white = brokenPine.textAlt;
        };
      };
    };
  };
}
