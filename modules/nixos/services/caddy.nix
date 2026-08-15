{ lib, pkgs, ... }: {
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-CjL8dMdnsiawaPiQGRvL3he4Ydd3nIbQs6tBWMwUbaw=";
    };

    # Certificates are validated with Porkbun DNS-01. This produces trusted
    # HTTPS certificates without exposing private services to the Internet.
    globalConfig = ''
      acme_dns porkbun {
        api_key {env.PORKBUN_API_KEY}
        api_secret_key {env.PORKBUN_API_SECRET_KEY}
      }
    '';

    # Private services resolve to the NetBird address and are only accepted on
    # wt0 by the firewall below. DNS-01 does not need public A/AAAA records.
    virtualHosts = {
      "home.rafh.io" = {
        hostName = "home.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8080";
      };
      "dns.rafh.io" = {
        hostName = "dns.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:3000";
      };
      "uptime.rafh.io" = {
        hostName = "uptime.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:3001";
      };
      "beszel.rafh.io" = {
        hostName = "beszel.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8090";
      };
      "vault.rafh.io" = {
        hostName = "vault.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8222";
      };
      "photos.rafh.io" = {
        hostName = "photos.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:2283";
      };
      "drive.rafh.io" = {
        hostName = "drive.rafh.io";
        extraConfig = "reverse_proxy 127.0.0.1:8081";
      };
    };
  };

  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 80 443 ];
}
