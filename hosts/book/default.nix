{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../modules/nixos
    ../../modules/nixos/docker.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "book";

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  boot = {
    loader.timeout = 3;
    # The Ryzen AI 9 465 uses the amd-pstate EPP interface.
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    firmware = with pkgs; [
      sof-firmware
      alsa-firmware
    ];
  };

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
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
          turbo = "auto";
          energy_performance_preference = "balance_performance";
        };
      };
    };
    # auto-cpufreq owns power profiles on this host.
    power-profiles-daemon.enable = false;
  };

  powerManagement.enable = true;

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  users.groups.video = {};

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    SDL_VIDEODRIVER = "wayland";
  };
}
