{ ... }: {
  services.caddy = {
    enable = true;

    # Private services are reached through the encrypted NetBird network. DNS
    # challenge/TLS for rafh.io will be added later with a SOPS-managed token.
    virtualHosts = {
      "home.rafh.io" = {
        hostName = "http://home.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8080";
      };
      "dns.rafh.io" = {
        hostName = "http://dns.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:3000";
      };
      "uptime.rafh.io" = {
        hostName = "http://uptime.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:3001";
      };
      "beszel.rafh.io" = {
        hostName = "http://beszel.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8090";
      };
      "vault.rafh.io" = {
        hostName = "http://vault.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8222";
      };
      "photos.rafh.io" = {
        hostName = "http://photos.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:2283";
      };
      "drive.rafh.io" = {
        hostName = "http://drive.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8081";
      };
    };
  };

  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 80 ];
}
