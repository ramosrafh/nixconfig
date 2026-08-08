{ ... }: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = [ "--disable=traefik" ];
  };

  networking.firewall.interfaces."wt0".allowedTCPPorts = [ 6443 ];
}
