{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    # inputs.niri.nixosModules.niri
  ];

  system.stateVersion = "25.05";
  networking.hostName = "nix";

  boot.loader.timeout = 3;

  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
