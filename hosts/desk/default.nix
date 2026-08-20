{ ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos/base
    ../../modules/nixos/profiles/workstation
    ../../modules/nixos/programs/adb.nix
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/programs/steam.nix
    ../../modules/nixos/services/docker.nix
    ../../modules/nixos/services/localsend.nix
    ../../modules/nixos/services/netbird.nix
    ../../modules/nixos/virtualization/windows-vm.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "desk";

  # llama.cpp runs in the desktop Compose stack. Its API is reachable only
  # through the NetBird interface, for the homelab server to consume.
  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 8080 ];

  boot.loader = {
    timeout = 3;
    limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 3;

      style = {
        wallpapers = [ ];
        interface.helpHidden = true;
        interface.branding = "NixOS";
      };
    };
  };

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
