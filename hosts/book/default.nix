{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/acpi.nix
  ];

  system.stateVersion = "25.05";
  networking.hostName = "nix";

  boot = {
    loader.timeout = 3;
    # Intel Ultra 7 258V - Lunar Lake with integrated Arc graphics
    kernelParams = [
      "i915.enable_guc=3"
      "i915.enable_dc=2"
      "i915.enable_fbc=0"
      "i915.enable_psr=0"
      "i915.fastboot=0"
      # ACPI settings for Lunar Lake
      "acpi_osi=Linux"
      "acpi_backlight=native"
      "pci=noaer"
      # CPU governor
      "intel_pstate=active"
      # NVMe power management
      "nvme_core.default_ps_max_latency_us=0"
      # Suspend/resume fixes
      "button.lid_init_state=open"
      "mem_sleep_default=s2idle"
    ];
    blacklistedKernelModules = [ "intel_ish_ipc" "intel_ishtp" ];
    kernelModules = [ "i915" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    intel-gpu-tools.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
        vulkan-loader
        vulkan-validation-layers
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
      ];
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
          turbo = "never";
          energy_performance_preference = "power";
        };
        charger = {
          governor = "powersave";
          turbo = "never";
          energy_performance_preference = "balance_power";
        };
      };
    };
  };

  # Intel graphics power management - PSR/DC disabled to fix suspend freeze
  boot.extraModprobeConfig = ''
    options i915 enable_guc=3 enable_dc=2 enable_fbc=0 enable_psr=0 fastboot=0
  '';

  # Backlight control permissions for brightnessctl
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # Add user to video group (handled in users.nix, but ensure video group exists)
  users.groups.video = {};

  # Environment variables for Intel Arc graphics
  environment.sessionVariables = {
    # Force Vulkan to use Intel
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
    # Force Mesa to use Intel Iris driver
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    # Mesa/Intel optimizations
    MESA_VK_VERSION_OVERRIDE = "1.3";
    ANV_VIDEO_DECODE = "1";
    # Intel debug flags to fix rendering issues
    INTEL_DEBUG = "norbc";
    # Native Wayland
    SDL_VIDEODRIVER = "wayland";
  };
}
