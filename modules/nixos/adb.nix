{ pkgs, ... }: {
  # Additional Android tools (fastboot, etc.)
  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
