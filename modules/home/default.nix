{ pkgs, ... }: {
  imports = [
    ./helix.nix
    ./yazi.nix
    ./fuzzel.nix
    ./zellij.nix
    ./terminal.nix
    ./fish.nix
    ./waybar.nix
    ./swww.nix
  ];

  home.stateVersion = "24.05";
  
  home.packages = with pkgs; [
    firefox
    alacritty
    fuzzel
    zellij
    yazi
    waybar
    swww
  ];

  home.sessionVariables = {
    EDITOR = "helix";
  };
}
