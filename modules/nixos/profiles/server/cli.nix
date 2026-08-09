{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    atuin
    fzf
    git
    helix
    jq
    nvme-cli
    ripgrep
    smartmontools
    syswatch
    zoxide
  ];

  environment = {
    etc."atuin/config.toml".text = ''
      auto_sync = false
      update_check = false
    '';
    sessionVariables.ATUIN_CONFIG_DIR = "/etc/atuin";
  };

  programs.fish.interactiveShellInit = ''
    ${pkgs.zoxide}/bin/zoxide init fish | source
    ${pkgs.fzf}/bin/fzf --fish | source
    ${pkgs.atuin}/bin/atuin init fish | source

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
