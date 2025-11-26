{ pkgs, ... }: {
  programs.git = {
    enable = true;

    # Git settings (new format)
    settings = {
      # User identity (default/personal)
      user = {
        name = "Rafael Ramos";
        email = "ramosrafh@gmail.com";
      };

      # General settings
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core = {
        editor = "helix";
        sshCommand = "ssh -i ~/.ssh/ramos";
      };

      # Conditional includes for work directories
      includeIf = {
        "gitdir:~/work/".path = "~/.config/git/config-work";
        "gitdir:~/driva/".path = "~/.config/git/config-work";
      };

      # Aliases
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };

  # Work Git configuration
  home.file.".config/git/config-work".text = ''
    [user]
      name = Rafael Ramos
      email = rafael@driva.com.br
    [core]
      sshCommand = ssh -i ~/.ssh/driva
  '';

  # SSH configuration for Git
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      # Personal GitHub account
      "github.com-ramos" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ramos";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };

      # Work GitHub account
      "github.com-driva" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/driva";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };

      # Default to personal account
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/ramos";
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
    };
  };
}
