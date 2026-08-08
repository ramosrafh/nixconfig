{ ... }:

{
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
