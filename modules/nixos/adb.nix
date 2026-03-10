{ pkgs, ... }: {
  # Enable ADB (Android Debug Bridge)
  # This provides udev rules for device access and adds adb to the system
  programs.adb.enable = true;

  # Additional Android tools (fastboot, etc.)
  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
