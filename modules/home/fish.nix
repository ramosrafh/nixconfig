{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat --paging=never";
      catp = "bat --paging=never --style=plain";
    };
    shellInit = ''
      set -g fish_greeting
    '';
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      # Minimal prompt format
      format = "$directory$git_branch$git_status$character";

      # Add a line break between prompts for breathing room
      add_newline = true;

      # Character that changes based on success/failure
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      # Directory configuration
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style) ";
        style = "bold cyan";
      };

      # Git branch
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold purple";
      };

      # Git status with minimal symbols
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold yellow";
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

      # Show command duration for long commands
      cmd_duration = {
        disabled = false;
        format = "[$duration]($style) ";
        min_time = 2000;
        style = "bold yellow";
      };

      # Show language/environment only when in project
      nodejs = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold green";
        disabled = false;
      };

      python = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold yellow";
        disabled = false;
      };

      rust = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
        style = "bold red";
        disabled = false;
      };

      # Disable everything else for true minimalism
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      docker_context.disabled = true;
      package.disabled = true;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin-mocha";
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
      # Use compact mode for minimal UI
      style = "compact";

      # Catppuccin Mocha theme colors
      inline_height = 14;

      # Search settings
      filter_mode_shell_up_key_binding = "directory";
      search_mode = "fuzzy";
      invert = true;
      enter_accept = true;

      # Disable up arrow key binding
      keymap_mode = "vim-insert";

      # UI preferences
      show_preview = true;
      show_help = false;
      exit_mode = "return-original";



      # History settings
      history_filter = [
        "^ls"
        "^cd"
        "^exit"
        "^clear"
      ];
    };
  };
}
