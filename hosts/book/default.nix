{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/acpi.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "nix";

  boot = {
    loader.timeout = 3;
    # Lunar Lake graphics and suspend tuning.
    kernelParams = [
      "i915.enable_guc=3"
      "i915.enable_dc=2"
      "i915.enable_fbc=0"
      "i915.enable_psr=0"
      "i915.fastboot=0"
      "acpi_osi=Linux"
      "acpi_backlight=native"
      "pci=noaer"
      "intel_pstate=active"
      "nvme_core.default_ps_max_latency_us=5500"
      "button.lid_init_state=open"
      "mem_sleep_default=s2idle"
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
    firmware = with pkgs; [
      sof-firmware
      alsa-firmware
    ];
  };

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
          scaling_max_freq = 2800000;
        };
        charger = {
          governor = "performance";
          turbo = "auto";
          energy_performance_preference = "balance_performance";
        };
      };
    };
    # auto-cpufreq owns power profiles on this host.
    power-profiles-daemon.enable = false;
  };

  # PSR/DC are disabled to avoid suspend freezes on this Intel GPU.
  boot.extraModprobeConfig = ''
    options i915 enable_guc=3 enable_dc=2 enable_fbc=0 enable_psr=0 fastboot=0
  '';

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  users.groups.video = {};

  environment.sessionVariables = {
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/intel_icd.x86_64.json";
    MESA_LOADER_DRIVER_OVERRIDE = "iris";
    MESA_VK_VERSION_OVERRIDE = "1.3";
    ANV_VIDEO_DECODE = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling is handled by auto-cpufreq.
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";
      CPU_SCALING_GOVERNOR_ON_AC = "";
      CPU_SCALING_GOVERNOR_ON_BAT = "";

      INTEL_GPU_MIN_FREQ_ON_AC = 100;
      INTEL_GPU_MIN_FREQ_ON_BAT = 100;
      INTEL_GPU_MAX_FREQ_ON_AC = 2250;
      INTEL_GPU_MAX_FREQ_ON_BAT = 1100;
      INTEL_GPU_BOOST_FREQ_ON_AC = 2250;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1100;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;

      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "min_power";

      NVME_POWER_ON_AC = 5;
      NVME_POWER_ON_BAT = 5;

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      WOL_DISABLE = "Y";
    };
  };
}
