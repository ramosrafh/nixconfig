{ primaryUser, ... }: {
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    extraConfig = "AllowUsers ${primaryUser}";
  };

  # NetBird creates wt0; SSH is intentionally unavailable on public/LAN interfaces.
  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 22 ];
}
