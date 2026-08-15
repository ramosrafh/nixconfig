{ lib, pkgs, ... }:
let
  tlsConfig = ''
    tls {
      dns porkbun {
        api_key {env.PORKBUN_API_KEY}
        api_secret_key {env.PORKBUN_API_SECRET_KEY}
      }
      # Porkbun DNS can take longer than Caddy's two-minute default to become
      # visible on public resolvers.
      propagation_timeout 10m
      resolvers 1.1.1.1 8.8.8.8
    }
  '';

  mkPrivateHost = hostName: upstream: {
    inherit hostName;
    extraConfig = ''
      ${tlsConfig}
      reverse_proxy ${upstream}
    '';
  };
in
{
  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/porkbun@v0.3.1" ];
      hash = "sha256-CjL8dMdnsiawaPiQGRvL3he4Ydd3nIbQs6tBWMwUbaw=";
    };

    # Private services resolve to the NetBird address and are only accepted on
    # wt0 by the firewall below. DNS-01 does not need public A/AAAA records.
    # Keep only running services here; add the next proxy when its service is
    # actually deployed, avoiding unnecessary DNS-01 requests.
    virtualHosts = {
      "home.rafh.io" = mkPrivateHost "home.rafh.io" "127.0.0.1:8080";
      "dns.rafh.io" = mkPrivateHost "dns.rafh.io" "127.0.0.1:3000";
      "uptime.rafh.io" = mkPrivateHost "uptime.rafh.io" "127.0.0.1:3001";
      "beszel.rafh.io" = mkPrivateHost "beszel.rafh.io" "127.0.0.1:8090";
      "vault.rafh.io" = mkPrivateHost "vault.rafh.io" "127.0.0.1:8222";
    };
  };

  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 80 443 ];
}
