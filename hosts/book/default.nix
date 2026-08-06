{ lib, pkgs, ... }:
let
  powerKeyGuard = "/run/power-key-suspend-guard";
  suspendOnPowerKey = pkgs.writeShellScript "suspend-on-power-key" ''
    if ${pkgs.coreutils}/bin/mkdir ${powerKeyGuard} 2>/dev/null; then
      if ! ${pkgs.systemd}/bin/systemctl suspend; then
        ${pkgs.coreutils}/bin/rmdir ${powerKeyGuard}
        exit 1
      fi
    fi
  '';
in {
  imports = [
    ./hardware.nix
    ./disko.nix
    ./secure-boot.nix
    ./snapshots.nix
    ../../modules/nixos
    ../../modules/nixos/docker.nix
  ];

  system.stateVersion = "26.05";
  networking.hostName = "book";
  console.keyMap = lib.mkForce "us";

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  virtualisation.docker.storageDriver = "overlay2";

  boot = {
    loader.timeout = 3;
    consoleLogLevel = 0;
    initrd.verbose = false;
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
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
      HoldoffTimeoutSec = "2s";
    };
    triggerhappy = {
      enable = true;
      user = "root";
      bindings = [{
        keys = [ "POWER" ];
        event = "release";
        cmd = "${suspendOnPowerKey}";
      }];
    };
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

  powerManagement = {
    enable = true;
    powerDownCommands = ''
      ${pkgs.coreutils}/bin/mkdir -p ${powerKeyGuard}
    '';
    resumeCommands = ''
      ${pkgs.coreutils}/bin/sleep 2
      ${pkgs.coreutils}/bin/rmdir ${powerKeyGuard} 2>/dev/null || true
    '';
  };

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
