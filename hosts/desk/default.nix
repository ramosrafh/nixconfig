{ ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/docker.nix
    ../../modules/nixos/steam.nix
    ../../modules/nixos/ollama.nix
    ../../modules/nixos/virtualization/windows-vm.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "desk";

  boot.loader.timeout = 3;

  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    AMD_VULKAN_ICD = "RADV";
  };
}
