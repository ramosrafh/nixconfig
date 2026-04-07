{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/acpi.nix
  ];

  system.stateVersion = "26.05";
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
      # CPU governor - HWP for Lunar Lake efficiency cores
      "intel_pstate=active"
      # NVMe power management - allow power saving (remove =0 to enable APST)
      "nvme_core.default_ps_max_latency_us=5500"
      # Suspend/resume fixes
      "button.lid_init_state=open"
      "mem_sleep_default=s2idle"
      # Enable ASPM for PCIe power savings
      "pcie_aspm=force"
      "pcie_aspm.policy=powersupersave"
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
          # Lunar Lake efficiency - limit max frequency on battery
          scaling_max_freq = 2800000;
        };
        charger = {
          governor = "performance";
          turbo = "auto";
          energy_performance_preference = "balance_performance";
        };
      };
    };
    # Enable power-profiles-daemon for GUI power profile switching
    power-profiles-daemon.enable = false; # Conflicts with auto-cpufreq, keep disabled
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
    # Native Wayland
    SDL_VIDEODRIVER = "wayland";
  };

  # Enable TLP for additional battery optimizations (works alongside auto-cpufreq)
  # CPU scaling is handled by auto-cpufreq, TLP handles other subsystems
  services.tlp = {
    enable = true;
    settings = {
      # DISABLE CPU management - let auto-cpufreq handle it
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";
      # Don't let TLP set governor - auto-cpufreq does this
      CPU_SCALING_GOVERNOR_ON_AC = "";
      CPU_SCALING_GOVERNOR_ON_BAT = "";

      # Intel GPU power management (Lunar Lake Xe)
      INTEL_GPU_MIN_FREQ_ON_AC = 100;
      INTEL_GPU_MIN_FREQ_ON_BAT = 100;
      INTEL_GPU_MAX_FREQ_ON_AC = 2250;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1100;
      INTEL_GPU_BOOST_FREQ_ON_AC = 2250;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1100;

      # WiFi power saving (Intel BE200)
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Audio power saving (handled by snd_hda_intel in acpi.nix too)
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # USB autosuspend - save power on idle USB devices
      USB_AUTOSUSPEND = 1;
      # Exclude input devices from autosuspend (mouse, keyboard)
      USB_EXCLUDE_BTUSB = 1;

      # Runtime PM for PCIe/SATA devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # SATA link power management
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "min_power";

      # NVMe power management (complements kernel param)
      NVME_POWER_ON_AC = 5;
      NVME_POWER_ON_BAT = 5;

      # Platform profile (ASUS)
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Disable WoL for power savings
      WOL_DISABLE = "Y";
    };
  };
}
