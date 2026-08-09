{ ... }: {
  # LocalSend discovers and transfers files over this port.
  networking.firewall = {
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };
}
