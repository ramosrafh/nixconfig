{ lib, pkgs, primaryUser, ... }: {
  virtualisation.docker = {
    enable = true;
    # Hosts can select a different driver without changing existing machines.
    storageDriver = lib.mkDefault "btrfs";
    daemon.settings = {
      "data-root" = lib.mkDefault "/docker";
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];

  users.users.${primaryUser}.extraGroups = [ "docker" ];
}
