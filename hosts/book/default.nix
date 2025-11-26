{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
  ];

  system.stateVersion = "25.05";
  networking.hostName = "nix";

  # Boot Configuration
  boot = {
    loader.timeout = 3;
    # Intel Ultra 7 258V - Lunar Lake with integrated Arc graphics
    kernelParams = [
      "i915.enable_guc=3"
    ];
  };

  # Hardware Configuration
  hardware = {
    enableRedistributableFirmware = true;
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
  };

  # Services Configuration
  services = {
    thermald.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "auto";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  # Power Management
  powerManagement.enable = true;
}
