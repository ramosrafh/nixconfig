{ pkgs, primaryUser, ... }: {
  users.users.${primaryUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
