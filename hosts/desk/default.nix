{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    inputs.niri.nixosModules.niri
  ];

  networking.hostName = "desk";
  
  boot.loader.timeout = 2;

  hardware.enableRedistributableFirmware = true;
  
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  system.stateVersion = "24.05";
}
