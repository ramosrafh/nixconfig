{ pkgs, ... }:
let
  glanceAssets = pkgs.runCommand "glance-assets" { } ''
    mkdir -p "$out"
    cp ${./glance.css} "$out/glance.css"
  '';
in
{
  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 8080;
        assets-path = "${glanceAssets}";
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
        custom-css-file = "/assets/glance.css";
      };

      pages = [
        {
          name = "Startpage";
          slug = "start";
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
                { type = "calendar"; }
                {
                  type = "rss";
                  title = "NixOS & self-hosting";
                  style = "vertical-list";
                  cache = "1h";
                  limit = 8;
                  collapse-after = 4;
                  feeds = [
                    {
                      title = "NixOS";
                      url = "https://nixos.org/blog/announcements-rss.xml";
                    }
                    {
                      title = "selfh.st";
                      url = "https://selfh.st/rss/";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {
                      type = "hacker-news";
                      title = "Hacker News";
                      sort-by = "top";
                      limit = 12;
                      collapse-after = 6;
                    }
                    {
                      type = "reddit";
                      title = "Homelab";
                      subreddit = "homelab";
                      sort-by = "hot";
                      limit = 12;
                      collapse-after = 6;
                    }
                    {
                      type = "reddit";
                      title = "Niri WM";
                      subreddit = "niri";
                      sort-by = "hot";
                      limit = 12;
                      collapse-after = 6;
                    }
                  ];
                }
                {
                  type = "videos";
                  title = "Vídeos";
                  cache = "30m";
                  style = "horizontal-cards";
                  limit = 10;
                  collapse-after = 3;
                  channels = [
                    # Gaules, CazeTV, O POVO.
                    "UC5ZTRH1zclthyc6b_D3m2Pw"
                    "UCZiYbVptd3PVPf4f6eR6UaQ"
                    "UCj-RTZE-V3Q6jleatRR9k2A"
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Curitiba, Brazil";
                }
                {
                  type = "markets";
                  title = "Cripto";
                  cache = "1m";
                  markets = [
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                    }
                    {
                      symbol = "SOL-USD";
                      name = "Solana";
                    }
                  ];
                }
              ];
            }
          ];
        }
        {
          name = "Homelab";
          slug = "homelab";
          width = "wide";
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
