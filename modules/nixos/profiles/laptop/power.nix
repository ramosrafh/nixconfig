{ ... }: {
  boot.kernelParams = [ "mem_sleep_default=s2idle" ];

  services = {
    fwupd.enable = true;
    fstrim.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
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
    power-profiles-daemon.enable = false;
  };
}
