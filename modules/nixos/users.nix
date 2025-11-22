{ pkgs, ... }: {
  users.users.ramos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
