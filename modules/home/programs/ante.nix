{
  config,
  lib,
  pkgs,
  ...
}:
let
  drivaBaseUrl = "http://vpn-driva.netbird.driva.io:8317/v1";

  catalogOverlay = pkgs.writeText "ante-catalog-overlay.json" (
    builtins.toJSON {
      providers.driva = {
        display_name = "Driva";
        base_url = drivaBaseUrl;
        wire_style = "OpenAiResponse";
        auth.header = {
          name = "x-api-key";
          env_key = "OPENAI_API_KEY";
        };
        preferred_models = [
          {
            id = "gpt-5.6-sol";
            display_name = "Driva GPT-5.6 Sol";
            effort = "high";
          }
        ];
      };
    }
  );

  mcpPostgres = pkgs.writeTextFile {
    name = "mcp-postgres";
    destination = "/bin/mcp-postgres";
    executable = true;
    text = ''
      #!${pkgs.fish}/bin/fish

      if test -f ~/.config/fish/secrets.fish
        source ~/.config/fish/secrets.fish
      end

      set -l database_variable $argv[1]
      set -l instance_name $argv[2]
      if test -z "$database_variable" -o -z "$instance_name"
        echo "usage: mcp-postgres <connection-variable> <instance-name>" >&2
        exit 2
      end
      if not set -q $database_variable
        echo "$database_variable is not set" >&2
        exit 1
      end

      set -q MCP_POSTGRES_MCP_IMAGE; or set MCP_POSTGRES_MCP_IMAGE crystaldba/postgres-mcp:latest
      set -l readonly_uri (printenv $database_variable)
      if string match -q --regex "\\?" -- "$readonly_uri"
        set readonly_uri "$readonly_uri&options=-c%20default_transaction_read_only%3Don"
      else
        set readonly_uri "$readonly_uri?options=-c%20default_transaction_read_only%3Don"
      end

      ${pkgs.docker}/bin/docker rm -f "postgres-mcp-$instance_name-$fish_pid" 2>/dev/null
      exec ${pkgs.docker}/bin/docker run --rm --name "postgres-mcp-$instance_name-$fish_pid" -i --network host --entrypoint postgres-mcp "$MCP_POSTGRES_MCP_IMAGE" --access-mode restricted "$readonly_uri"
    '';
  };

  mcpClickhouse = pkgs.writeTextFile {
    name = "mcp-clickhouse";
    destination = "/bin/mcp-clickhouse";
    executable = true;
    text = ''
      #!${pkgs.fish}/bin/fish

      if test -f ~/.config/fish/secrets.fish
        source ~/.config/fish/secrets.fish
      end

      set -q MCP_CLICKHOUSE_MCP_IMAGE; or set MCP_CLICKHOUSE_MCP_IMAGE mcp/clickhouse:latest
      set -q MCP_CLICKHOUSE_SECURE; or set MCP_CLICKHOUSE_SECURE false
      set -q MCP_CLICKHOUSE_VERIFY; or set MCP_CLICKHOUSE_VERIFY true
      set -q MCP_CLICKHOUSE_CONNECT_TIMEOUT; or set MCP_CLICKHOUSE_CONNECT_TIMEOUT 10
      set -q MCP_CLICKHOUSE_SEND_RECEIVE_TIMEOUT; or set MCP_CLICKHOUSE_SEND_RECEIVE_TIMEOUT 30

      ${pkgs.docker}/bin/docker rm -f "clickhouse-mcp-$fish_pid" 2>/dev/null
      exec ${pkgs.docker}/bin/docker run --rm --name "clickhouse-mcp-$fish_pid" -i --network host -e "CLICKHOUSE_HOST=$MCP_CLICKHOUSE_HOST" -e "CLICKHOUSE_PORT=$MCP_CLICKHOUSE_PORT" -e "CLICKHOUSE_USER=$MCP_CLICKHOUSE_USER" -e "CLICKHOUSE_PASSWORD=$MCP_CLICKHOUSE_PASSWORD" -e "CLICKHOUSE_DATABASE=$MCP_CLICKHOUSE_DATABASE" -e "CLICKHOUSE_SECURE=$MCP_CLICKHOUSE_SECURE" -e "CLICKHOUSE_VERIFY=$MCP_CLICKHOUSE_VERIFY" -e "CLICKHOUSE_CONNECT_TIMEOUT=$MCP_CLICKHOUSE_CONNECT_TIMEOUT" -e "CLICKHOUSE_SEND_RECEIVE_TIMEOUT=$MCP_CLICKHOUSE_SEND_RECEIVE_TIMEOUT" "$MCP_CLICKHOUSE_MCP_IMAGE"
    '';
  };

  postgresMcp = databaseVariable: instanceName: {
    command = "${mcpPostgres}/bin/mcp-postgres";
    args = [
      databaseVariable
      instanceName
    ];
  };

  settingsOverlay = pkgs.writeText "ante-settings-overlay.json" (
    builtins.toJSON {
      model = "gpt-5.6-sol";
      provider = "driva";
      skills = true;
      model_effort."gpt-5.6-sol" = "high";
      provider_model = {
        driva = "gpt-5.6-sol";
        "openrouter-responses" = "openai/gpt-5.6-sol";
      };
      mcp_servers = {
        postgres_kipflow = postgresMcp "MCP_POSTGRES_KIPFLOW" "kipflow";
        postgres_auth = postgresMcp "MCP_POSTGRES_AUTH" "auth";
        clickhouse = {
          command = "${mcpClickhouse}/bin/mcp-clickhouse";
        };
      };
    }
  );
in
{
  home.packages = [
    mcpPostgres
    mcpClickhouse
  ];

  # Ante does not discover the legacy ~/.codex/skills directory. Reuse the
  # existing user skills without copying their assets into the Nix store.
  home.file = {
    ".ante/skills/driva-slides".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.codex/skills/driva-slides";
    ".ante/skills/frontend-slides".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.codex/skills/frontend-slides";
  };

  # settings.json is intentionally a mutable file: Ante updates preferences
  # from its TUI. Merge only the machine-owned provider/MCP defaults on switch.
  home.activation.configureAnte = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ante_home_dir="${config.home.homeDirectory}/.ante"
    ${pkgs.coreutils}/bin/mkdir -p "$ante_home_dir"

    merge_ante_json() {
      target="$1"
      overlay="$2"
      temporary="$(${pkgs.coreutils}/bin/mktemp "$ante_home_dir/.ante-config.XXXXXX")"

      if test -s "$target"; then
        if ! ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$overlay" > "$temporary"; then
          ${pkgs.coreutils}/bin/rm -f "$temporary"
          return 1
        fi
      else
        ${pkgs.coreutils}/bin/cp "$overlay" "$temporary"
      fi

      ${pkgs.coreutils}/bin/chmod 600 "$temporary"
      ${pkgs.coreutils}/bin/mv "$temporary" "$target"
    }

    merge_ante_json "$ante_home_dir/catalog.json" "${catalogOverlay}"
    merge_ante_json "$ante_home_dir/settings.json" "${settingsOverlay}"
  '';
}
