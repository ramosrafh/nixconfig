{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.enable = false;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.2.51/32" ];
      listenPort = 51820;

      privateKeyFile = "/etc/wireguard/private.key";

      postSetup = ''
        ${pkgs.systemd}/bin/resolvectl dns wg0 10.0.2.1
        ${pkgs.systemd}/bin/resolvectl domain wg0 "~."
      '';

      peers = [
        {
          publicKey = "6adUOk0C0C7e68PSNX1g40aGtfQsZ2VfGz2xdbGvPUg=";
          endpoint = "149.56.25.87:51820";
          allowedIPs = [ "10.0.2.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
