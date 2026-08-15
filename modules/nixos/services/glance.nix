{ ... }: {
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
        # Glance is only reached through Caddy on the NetBird interface.
        proxied = true;
      };

      # A restrained dark theme close to Glance's reference dashboard, with a
      # little more contrast for daily use.
      theme = {
        background-color = "240 8 9";
        primary-color = "43 50 70";
        positive-color = "52 58 65";
        negative-color = "0 70 70";
        contrast-multiplier = 1.1;
      };

      pages = [
        {
          name = "Homelab";
          slug = "homelab";
          width = "wide";
          head-widgets = [
            {
              type = "search";
              search-engine = "duckduckgo";
              new-tab = true;
              placeholder = "Buscar na web…";
              bangs = [
                {
                  title = "GitHub";
                  shortcut = "gh";
                  url = "https://github.com/search?q={QUERY}";
                }
                {
                  title = "Nix packages";
                  shortcut = "nix";
                  url = "https://search.nixos.org/packages?query={QUERY}";
                }
              ];
            }
          ];
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "server-stats";
                  title = "Server";
                  servers = [
                    {
                      type = "local";
                      name = "server";
                      hide-swap = true;
                      hide-mountpoints-by-default = true;
                      mountpoints = {
                        "/".name = "Sistema";
                        "/srv/homelab".name = "Dados";
                      };
                    }
                  ];
                }
                {
                  type = "releases";
                  title = "Atualizações";
                  cache = "12h";
                  show-source-icon = true;
                  collapse-after = 4;
                  repositories = [
                    "glanceapp/glance"
                    "caddyserver/caddy"
                    "AdguardTeam/AdGuardHome"
                    "netbirdio/netbird"
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "monitor";
                  title = "Serviços";
                  cache = "30s";
                  sites = [
                    {
                      title = "Glance";
                      url = "http://home.rafh.io";
                      check-url = "http://127.0.0.1:8080";
                      icon = "mdi:view-dashboard";
                      same-tab = true;
                    }
                    {
                      title = "AdGuard Home";
                      url = "http://dns.rafh.io";
                      check-url = "http://127.0.0.1:3000";
                      icon = "si:adguard";
                      same-tab = true;
                    }
                    {
                      title = "Uptime Kuma";
                      url = "http://uptime.rafh.io";
                      check-url = "http://127.0.0.1:3001";
                      icon = "si:uptimekuma";
                      same-tab = true;
                    }
                    {
                      title = "Beszel";
                      url = "http://beszel.rafh.io";
                      check-url = "http://127.0.0.1:8090";
                      icon = "si:beszel";
                      same-tab = true;
                    }
                    {
                      title = "Vaultwarden";
                      url = "http://vault.rafh.io";
                      check-url = "http://127.0.0.1:8222";
                      icon = "si:vaultwarden";
                      same-tab = true;
                    }
                  ];
                }
                {
                  type = "bookmarks";
                  title = "Acessos";
                  groups = [
                    {
                      title = "Homelab";
                      links = [
                        {
                          title = "AdGuard Home";
                          url = "http://dns.rafh.io";
                          icon = "si:adguard";
                        }
                        {
                          title = "Uptime Kuma";
                          url = "http://uptime.rafh.io";
                          icon = "si:uptimekuma";
                        }
                        {
                          title = "Beszel";
                          url = "http://beszel.rafh.io";
                          icon = "si:beszel";
                        }
                        {
                          title = "Vaultwarden";
                          url = "http://vault.rafh.io";
                          icon = "si:vaultwarden";
                        }
                      ];
                    }
                    {
                      title = "Administração";
                      links = [
                        {
                          title = "NetBird";
                          url = "https://app.netbird.io";
                          icon = "si:netbird";
                        }
                        {
                          title = "Porkbun";
                          url = "https://porkbun.com/account/login";
                          icon = "mdi:domain";
                        }
                        {
                          title = "NixOS packages";
                          url = "https://search.nixos.org/packages";
                          icon = "si:nixos";
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
