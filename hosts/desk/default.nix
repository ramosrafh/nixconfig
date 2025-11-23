{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    # inputs.niri.nixosModules.niri
  ];

  networking.hostName = "nix";
  
  boot.loader.timeout = 3;

  hardware.enableRedistributableFirmware = true;
  
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  system.stateVersion = "25.05";
}
