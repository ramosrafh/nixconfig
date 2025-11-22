{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin-mocha";
    };
  };

  programs.eza.enable = true;
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
