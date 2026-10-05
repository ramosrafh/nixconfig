{ ... }: {
  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    mutableSettings = true;
  };

  # The dashboard is proxied by Caddy. DNS itself is reachable only over the
  # NetBird interface until a LAN DNS policy is deliberately added.
  networking.firewall.interfaces."wt0" = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
