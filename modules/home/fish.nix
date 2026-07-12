{ pkgs, ... }:
let
  brokenPine = import ./broken-pine.nix;
in {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat --paging=never";
      catp = "bat --paging=never --style=plain";
      zed = "zeditor";

      claude-max = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=claude/opus claude";
      claude-codex = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=codex/opus claude";
      claude-glm = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=glm/opus claude";
    };
    functions = {
      dev = {
        description = "Open a nixconfig devShell";
        body = ''
          set -l flake "path:$HOME/nixconfig"

          if test (count $argv) -eq 0
              nix develop "$flake"
          else
              nix develop "$flake#$argv[1]"
          end
        '';
      };

      claude-mcp-clickhouse = {
        description = "Register global ClickHouse MCP for Claude Code";
        body = ''
          claude mcp add-json clickhouse '{
            "type": "stdio",
            "command": "fish",
            "args": [
              "-lc",
              "if test -f ~/.config/fish/secrets.fish; source ~/.config/fish/secrets.fish; end; set -q CLICKHOUSE_MCP_IMAGE; or set -gx CLICKHOUSE_MCP_IMAGE mcp/clickhouse:latest; set -q CLICKHOUSE_SECURE; or set -gx CLICKHOUSE_SECURE false; set -q CLICKHOUSE_VERIFY; or set -gx CLICKHOUSE_VERIFY true; set -q CLICKHOUSE_CONNECT_TIMEOUT; or set -gx CLICKHOUSE_CONNECT_TIMEOUT 10; set -q CLICKHOUSE_SEND_RECEIVE_TIMEOUT; or set -gx CLICKHOUSE_SEND_RECEIVE_TIMEOUT 30; exec docker run --rm -i --network host -e CLICKHOUSE_HOST -e CLICKHOUSE_PORT -e CLICKHOUSE_USER -e CLICKHOUSE_PASSWORD -e CLICKHOUSE_DATABASE -e CLICKHOUSE_SECURE -e CLICKHOUSE_VERIFY -e CLICKHOUSE_CONNECT_TIMEOUT -e CLICKHOUSE_SEND_RECEIVE_TIMEOUT \"$CLICKHOUSE_MCP_IMAGE\""
            ]
          }' --scope user
        '';
      };

      __nixconfig_host = {
        body = ''
          switch "$argv[1]"
              case book desk
                  return 0
              case '*'
                  echo "host inválido: $argv[1]"
                  echo "use: book ou desk"
                  return 1
          end
        '';
      };

      nfu = {
        description = "Update nixconfig flake inputs";
        body = ''
          set -l nixconfig "$HOME/nixconfig"
          nix flake update --flake "$nixconfig"
        '';
      };

      nrs = {
        description = "Switch nixconfig host";
        body = ''
          __nixconfig_host "$argv[1]"; or return 1
          sudo nixos-rebuild switch --flake "path:$HOME/nixconfig#$argv[1]"
        '';
      };

      nrb = {
        description = "Build nixconfig host for next boot";
        body = ''
          __nixconfig_host "$argv[1]"; or return 1
          sudo nixos-rebuild boot --flake "path:$HOME/nixconfig#$argv[1]"
        '';
      };
    };
    shellInit = ''
      set -g fish_greeting

      # Load secrets outside the Nix store.
      if test -f ~/.config/fish/secrets.fish
          source ~/.config/fish/secrets.fish
      end
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = "$directory$git_branch$git_status$character";
      add_newline = true;

      character = {
        success_symbol = "[❯](bold success)";
        error_symbol = "[❯](bold error)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style) ";
        style = "bold accent";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold magenta";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold warning";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      cmd_duration = {
        disabled = false;
        format = "[$duration]($style) ";
        min_time = 2000;
        style = "bold warning";
      };

      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold success";
        disabled = false;
      };

      python = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold warning";
        disabled = false;
      };

      rust = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold error";
        disabled = false;
      };

      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      docker_context.disabled = true;
      package.disabled = true;
      palette = "broken_pine";
      palettes.broken_pine = {
        accent = brokenPine.blue;
        error = brokenPine.red;
        success = brokenPine.green;
        warning = brokenPine.yellow;
        magenta = brokenPine.magenta;
      };
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "Broken Pine";
    themes."Broken Pine" = {
      src = ./bat-broken-pine.tmTheme;
      file = null;
    };
  };

  programs.eza.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      sync_address = "";
      sync.records = false;
      style = "compact";
      inline_height = 14;
      filter_mode_shell_up_key_binding = "directory";
      search_mode = "fuzzy";
      invert = true;
      enter_accept = true;
      keymap_mode = "vim-insert";
      show_preview = true;
      show_help = false;
      exit_mode = "return-original";
      history_filter = [
        "^ls"
        "^cd"
        "^exit"
        "^clear"
      ];
    };
  };
}
