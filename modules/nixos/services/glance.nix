{ ... }: {
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
      };
      pages = [
        {
          name = "Homelab";
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "Infrastructure";
                      links = [
                        {
                          title = "AdGuard Home";
                          url = "http://dns.rafh.io";
                        }
                        {
                          title = "Uptime Kuma";
                          url = "http://uptime.rafh.io";
                        }
                        {
                          title = "Beszel";
                          url = "http://beszel.rafh.io";
                        }
                      ];
                    }
                    {
                      title = "Private services";
                      links = [
                        {
                          title = "Vaultwarden";
                          url = "http://vault.rafh.io";
                        }
                        {
                          title = "Immich";
                          url = "http://photos.rafh.io";
                        }
                        {
                          title = "Nextcloud";
                          url = "http://drive.rafh.io";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
