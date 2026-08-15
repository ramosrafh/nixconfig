{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    age
    atuin
    fzf
    git
    helix
    jq
    nvme-cli
    ripgrep
    smartmontools
    sops
    syswatch
    zoxide
  ];

  environment = {
    etc."atuin/config.toml".text = ''
      auto_sync = false
      update_check = false
      style = "compact"
      inline_height = 14
      filter_mode_shell_up_key_binding = "directory"
      search_mode = "fuzzy"
      invert = true
      enter_accept = true
      keymap_mode = "vim-insert"
      show_preview = true
      show_help = false
      exit_mode = "return-original"

      history_filter = [
        "^ls",
        "^cd",
        "^exit",
        "^clear",
      ]

      [sync]
      records = false
    '';
    sessionVariables.ATUIN_CONFIG_DIR = "/etc/atuin";
  };

  programs.fish.interactiveShellInit = ''
    ${pkgs.zoxide}/bin/zoxide init fish | source
    ${pkgs.fzf}/bin/fzf --fish | source
    ${pkgs.atuin}/bin/atuin init fish --disable-up-arrow | source

    function nrs --description "Switch the server configuration"
      sudo nixos-rebuild switch --flake "path:$HOME/nixconfig#server"
    end

    function nrb --description "Build the server configuration for next boot"
      sudo nixos-rebuild boot --flake "path:$HOME/nixconfig#server"
    end

    function nrt --description "Test the server configuration until reboot"
      sudo nixos-rebuild test --flake "path:$HOME/nixconfig#server"
    end
  '';
}
