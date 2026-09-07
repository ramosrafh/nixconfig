{ pkgs, ... }:
let
  vesper = import ../themes/vesper.nix;
in
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat --paging=never";
      catp = "bat --paging=never --style=plain";
      zed = "zeditor";
      t = "tmux new-session -A -s main";
      ta = "tmux attach-session";
      tls = "tmux list-sessions";

      claude-max = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=claude/opus claude";
      claude-codex = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=codex/opus claude";
      claude-glm = "env ANTHROPIC_BASE_URL=http://vpn-driva.netbird.driva.io:8317 ANTHROPIC_MODEL=glm/opus claude";
      ante-driva = "ante --provider driva --model gpt-5.6-sol";
      ante-openrouter = "ante --provider openrouter-responses --model openai/gpt-5.6-sol";
    };
    functions = {
      ssh = {
        description = "SSH with Kitty remote terminal integration";
        wraps = "ssh";
        body = ''
          if set -q KITTY_WINDOW_ID; and command -q kitten
              command kitten ssh $argv
          else
              command ssh $argv
          end
        '';
      };

      dev = {
        description = "Open a nixconfig devShell";
        body = ''
          set -l flake "path:$HOME/nixconfig"

          if test (count $argv) -eq 0
              nix develop "$flake" --command fish
          else
              nix develop "$flake#$argv[1]" --command fish
          end
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

      # Drop the legacy standalone Home Manager path if it was inherited by
      # an existing graphical session. NixOS Home Manager uses the per-user
      # profile under /etc/profiles/per-user instead.
      set -l legacy_home_path "$HOME/.local/state/nix/profiles/home-manager/home-path/bin"
      set -gx PATH (string match -v -- "$legacy_home_path" $PATH)

      # Load secrets outside the Nix store.
      if test -f ~/.config/fish/secrets.fish
          source ~/.config/fish/secrets.fish
      end
    '';

    interactiveShellInit = ''
      set -g fish_color_normal ${vesper.noHash vesper.text}
      set -g fish_color_command ${vesper.noHash vesper.yellow}
      set -g fish_color_keyword ${vesper.noHash vesper.muted}
      set -g fish_color_quote ${vesper.noHash vesper.green}
      set -g fish_color_redirection ${vesper.noHash vesper.yellow}
      set -g fish_color_end ${vesper.noHash vesper.muted}
      set -g fish_color_error ${vesper.noHash vesper.red}
      set -g fish_color_param ${vesper.noHash vesper.text}
      set -g fish_color_comment ${vesper.noHash vesper.mutedAlt}
      set -g fish_color_selection --background=${vesper.noHash vesper.surfaceVariant}
      set -g fish_color_search_match --background=${vesper.noHash vesper.surfaceActive}
      set -g fish_color_operator ${vesper.noHash vesper.muted}
      set -g fish_color_escape ${vesper.noHash vesper.green}
      set -g fish_color_autosuggestion ${vesper.noHash vesper.disabled}
      set -g fish_pager_color_progress ${vesper.noHash vesper.muted}
      set -g fish_pager_color_prefix ${vesper.noHash vesper.yellow} --bold
      set -g fish_pager_color_completion ${vesper.noHash vesper.text}
      set -g fish_pager_color_description ${vesper.noHash vesper.muted}
      set -g fish_pager_color_selected_background --background=${vesper.noHash vesper.surfaceVariant}
      set -g fish_pager_color_selected_prefix ${vesper.noHash vesper.yellow} --bold
      set -g fish_pager_color_selected_completion ${vesper.noHash vesper.text}
      set -g fish_pager_color_selected_description ${vesper.noHash vesper.muted}
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character";
      add_newline = true;

      username = {
        show_always = true;
        format = "[$user]($style) ";
        style_user = "bold blue";
        style_root = "bold error";
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style) ";
        style = "bold muted";
      };

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
        symbol = " ";
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
      palette = "vesper";
      palettes.vesper = {
        accent = vesper.yellow;
        error = vesper.red;
        success = vesper.green;
        warning = vesper.yellow;
        magenta = vesper.yellow;
        cyan = vesper.green;
        muted = vesper.muted;
      };
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "Vesper";
    themes.Vesper = {
      src = ../themes/vesper-bat.tmTheme;
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
