{ config, pkgs, ... }: {
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
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.fastboot=1"
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
    ];
    blacklistedKernelModules = [ "intel_ish_ipc" "intel_ishtp" ];
    kernelModules = [ "i915" ];
  };

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

  # Intel graphics power management
  boot.extraModprobeConfig = ''
    options i915 enable_guc=3 enable_dc=2 enable_fbc=1 enable_psr=1 fastboot=1
  '';

  # Ensure proper resume from suspend
  systemd.services.intel-graphics-workaround = {
    description = "Intel graphics workaround before suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.kmod}/bin/rmmod i915 2>/dev/null || true; ${pkgs.kmod}/bin/modprobe i915'";
    };
  };
}
