{ ... }: {
  services.resolved.enable = true;
  services.resolved.dnssec = "allow-downgrade";
  services.resolved.fallbackDns = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      53317  # LocalSend
      # 22     # SSH
      # 80     # HTTP
      # 443    # HTTPS
      # 3000   # Common dev server
      # 5173   # Vite dev server
      # 8080   # Alternative HTTP
    ];
    allowedUDPPorts = [
      53317  # LocalSend
    ];
  };
}
