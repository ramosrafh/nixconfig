{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    daemon.settings = {
      "data-root" = "/docker";
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];
}
