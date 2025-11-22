{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
  ];

  networking.hostName = "book";
  
  boot.loader.timeout = 0;
  
  hardware.enableRedistributableFirmware = true;
  services.thermald.enable = true;
  
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  system.stateVersion = "24.05";
}
