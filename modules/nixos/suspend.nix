{ pkgs, ... }: {
  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Disable hibernation completely, only use suspend-to-RAM
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  # Configure systemd-logind for suspend only (no hibernate)
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    IdleAction = "ignore";
    InhibitDelayMaxSec = 5;
    HoldoffTimeoutSec = 10;
  };

  # Systemd sleep configuration - force suspend-to-RAM only
  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
    SuspendState=mem
    SuspendMode=deep
  '';

  # Ensure hibernate targets are disabled
  systemd.targets = {
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Services configuration
  services.udev.extraRules = ''
    # Allow brightness control without sudo
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/backlight/%k/brightness"

    # Wake from suspend on lid open
    ACTION=="add", SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="Lid Switch", TAG+="power-switch"

    # Ensure USB devices can wake the system
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="enabled"
  '';

  # System service to prepare for suspend and handle resume
  systemd.services.suspend-preparation = {
    description = "Prepare system for suspend";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "suspend-prep" ''
        # Sync filesystems
        ${pkgs.util-linux}/bin/sync

        # Clear page cache to reduce resume time
        echo 1 > /proc/sys/vm/drop_caches || true
      ''}";
    };
  };

  # System service to fix issues after resume
  systemd.services.resume-fix = {
    description = "Fix system issues after resume from suspend";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "resume-fix" ''
        # Reload USB subsystem if needed
        ${pkgs.systemd}/bin/udevadm trigger --subsystem-match=usb

        # Restart network if needed
        ${pkgs.systemd}/bin/systemctl restart NetworkManager.service || true

        # Give the system a moment to stabilize
        sleep 2
      ''}";
    };
  };

  # User service to reload niri compositor on resume
  systemd.user.services.niri-reload-on-resume = {
    description = "Reload Niri compositor on resume";
    after = [ "suspend.target" ];
    wantedBy = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'sleep 1 && ${pkgs.systemd}/bin/systemctl --user restart niri.service || true'";
      RemainAfterExit = false;
    };
  };
}
