{ config, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/porkbun.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets.caddy-porkbun-env = {
      key = "caddy_porkbun_env";
      owner = "caddy";
      group = "caddy";
      mode = "0400";
    };
  };

  services.caddy.environmentFile = config.sops.secrets.caddy-porkbun-env.path;
}
