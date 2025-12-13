{ pkgs, ... }: {
  # Enable PAM authentication for hyprlock
  security.pam.services.hyprlock = {
    text = ''
      auth include login
    '';
  };

  # Install hyprlock at system level
  environment.systemPackages = with pkgs; [
    hyprlock
  ];
}
