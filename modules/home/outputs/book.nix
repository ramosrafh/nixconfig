{
  # Notebook internal display (Samsung Display Corp. 0x419D)
  "eDP-1" = {
    mode = {
      width = 2880;
      height = 1800;
      refresh = 120.0;
    };
    scale = 1.55;
    position = {
      x = 0;
      y = 1440; # Below external monitor
    };
  };

  # Home office - Gigabyte M27Q 2K monitor (top)
  "GIGA-BYTE TECHNOLOGY CO., LTD. M27Q 21330B005266" = {
    mode = {
      width = 2560;
      height = 1440;
      refresh = 169.831;
    };
    position = {
      x = 0;
      y = 0; # Top
    };
    scale = 1.0;
  };

  # Work 1080p monitor (placeholder - replace with actual EDID)
  # Run: niri msg outputs to get the real name
  "Samsung Electric Company LF24T450F HX5W500259" = {
    mode = {
      width = 1920;
      height = 1080;
      refresh = 74.973;
    };
    position = {
      x = 0;
      y = 0; # Top
    };
    scale = 1.0;
  };

  # Work presentation 2160p TV (placeholder - replace with actual EDID)
  # Run: niri msg outputs to get the real name
  "Samsung Electric Company SAMSUNG 0x01000E00" = {
    mode = {
      width = 3840;
      height = 2160;
      # refresh = 60.0;
    };
    position = {
      x = 0;
      y = 0; # Top
    };
    scale = 2.0;
  };
}
