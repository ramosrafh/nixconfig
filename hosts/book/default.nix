{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/acpi.nix
    ../../modules/nixos/docker.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "book";

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
}
