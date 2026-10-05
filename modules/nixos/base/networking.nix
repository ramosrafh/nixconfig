{ ... }: {
  services.resolved.enable = true;
  services.resolved.settings.Resolve.DNSSEC = "allow-downgrade";
  services.resolved.settings.Resolve.FallbackDNS = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

  # Private homelab names resolve only on machines that are part of this
  # configuration. They reach the server through NetBird, never through LAN.
  networking.hosts."100.102.43.4" = [
    "server.rafh.io"
    "home.rafh.io"
    "dns.rafh.io"
    "uptime.rafh.io"
    "beszel.rafh.io"
    "dsh.rafh.io"
    "vault.rafh.io"
    "photos.rafh.io"
    "drive.rafh.io"
  ];

  networking.firewall.enable = true;
}
