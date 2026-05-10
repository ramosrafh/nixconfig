{ pkgs, ... }: {
  users.users.ramos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "kvm" "video" "audio" "storage" "adbusers" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  security.sudo.wheelNeedsPassword = false;
}
