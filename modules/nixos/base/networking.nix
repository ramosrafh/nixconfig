{ ... }: {
  services.resolved.enable = true;
  services.resolved.settings.Resolve.DNSSEC = "allow-downgrade";
  services.resolved.settings.Resolve.FallbackDNS = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];

  networking.firewall.enable = true;
}
