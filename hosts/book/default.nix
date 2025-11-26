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
      # Suppress ACPI BIOS errors (these are firmware bugs, not real issues)
      "acpi_osi=Linux"
      "acpi_mask_gpe=0x6F"
      # Disable Intel ISH (Integrated Sensor Hub) - fixes intel_ish_ipc errors
      "intel_ish.dyndbg=+p"
      "pci=noaer"
    ];
    # Blacklist ISH driver if not needed
    blacklistedKernelModules = [ "intel_ish_ipc" ];
  };

  # Hardware Configuration
  hardware = {
    enableRedistributableFirmware = true;
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
    # Audio firmware for SOF
    firmware = with pkgs; [
      sof-firmware
      alsa-firmware
    ];
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
