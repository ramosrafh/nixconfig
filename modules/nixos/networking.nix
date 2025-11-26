{ ... }: {
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      53317  # LocalSend
    ];
    allowedUDPPorts = [
      53317  # LocalSend
    ];
  };
}
