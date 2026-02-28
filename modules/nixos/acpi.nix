{ config, lib, pkgs, ... }:

{
  # System sleep hook to trigger user notification resume service after suspend
  # This runs as root and signals the user session
  powerManagement.powerDownCommands = "";
  powerManagement.resumeCommands = ''
    # Give the system time to stabilize after resume
    sleep 2
    # Trigger notification-resume for all logged-in graphical sessions
    for user in $(loginctl list-users --no-legend | awk '{print $2}'); do
      uid=$(id -u "$user" 2>/dev/null || echo "")
      if [ -n "$uid" ] && [ -d "/run/user/$uid" ]; then
        su - "$user" -c "XDG_RUNTIME_DIR=/run/user/$uid systemctl --user start notification-resume.service" 2>/dev/null || true
      fi
    done
  '';

  boot.kernelParams = [
    "quiet"
    "loglevel=0"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=0"
    "udev.log_level=0"
    "acpi.debug_layer=0x0"
    "acpi.debug_level=0x0"
    "systemd.show_status=false"
    "vt.global_cursor_default=0"
  ];

  boot.plymouth.enable = false;

  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  # boot.blacklistedKernelModules = [
  #   "soundwire_intel"
  #   "soundwire_generic_allocation"
  #   "soundwire_cadence"
  #   "snd_intel_sdw_acpi"
  # ];

  boot.extraModprobeConfig = ''
    options snd_intel_dspcfg dsp_driver=3
    options snd_hda_intel power_save=1
    options snd_hda_intel probe_mask=1
  '';

  services.journald.extraConfig = ''
    RateLimitBurst=0
  '';

  # Additional power management for suspend/resume stability
  powerManagement.enable = true;
}
