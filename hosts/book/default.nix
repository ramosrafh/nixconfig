{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
  ];

  networking.hostName = "nix";

  boot.loader.timeout = 3;

  hardware.enableRedistributableFirmware = true;
  services.thermald.enable = true;

  # Intel Ultra 7 258V - Lunar Lake with integrated Arc graphics
  hardware.intel-gpu-tools.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Use auto-cpufreq instead of TLP for better CPU frequency management
  services.auto-cpufreq = {
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

  # Zenbook UX5406S specific optimizations
  boot.kernelParams = [
    "i915.enable_guc=3"  # Enable GuC and HuC firmware loading for Intel Arc graphics
  ];
</parameter>

  system.stateVersion = "26.05";
}
