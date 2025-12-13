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

  # Environment variables for gaming and refresh rate support
  environment.sessionVariables = {
    # Force games to use Wayland when possible
    SDL_VIDEODRIVER = "wayland";
    # AMD GPU optimizations
    AMD_VULKAN_ICD = "RADV";
    # Enable high refresh rate support
    WLR_DRM_NO_ATOMIC = "0";
    # Force VRR (Variable Refresh Rate) support
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  boot.kernelParams = [
    "amdgpu.dc=1"
    "amdgpu.dpm=1"
  ];
}
