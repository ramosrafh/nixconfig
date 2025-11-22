{ pkgs, ... }: {
  home.packages = with pkgs; [ swww ];
  
  home.file.".wallpapers/.keep".text = "";
}
