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
in
{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./snapshots.nix
    ../../modules/nixos/base
    ../../modules/nixos/profiles/workstation
    ../../modules/nixos/profiles/laptop
    ../../modules/nixos/programs/adb.nix
    ../../modules/nixos/programs/nix-ld.nix
    ../../modules/nixos/security/secure-boot.nix
    ../../modules/nixos/services/docker.nix
    ../../modules/nixos/services/localsend.nix
    ../../modules/nixos/services/netbird.nix
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
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HoldoffTimeoutSec = "2s";
    };
    triggerhappy = {
      enable = true;
      user = "root";
      bindings = [
        {
          keys = [ "POWER" ];
          event = "release";
          cmd = "${suspendOnPowerKey}";
        }
      ];
    };
    xserver.videoDrivers = [ "amdgpu" ];
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

  users.groups.video = { };

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    SDL_VIDEODRIVER = "wayland";
  };
}
