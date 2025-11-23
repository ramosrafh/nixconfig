{ ... }: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    daemon.settings = {
      "data-root" = "/docker";
    };
  };
}
