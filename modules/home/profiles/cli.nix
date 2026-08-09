{ pkgs, ... }: {
  imports = [
    ../programs/fish.nix
    ../programs/git.nix
    ../programs/helix.nix
    ../programs/ssh.nix
    ../programs/yazi.nix
    ../programs/zellij.nix
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    bottom
    unzip
    smartmontools
    nvme-cli
    syswatch
  ];

  home.sessionVariables = {
    EDITOR = "helix";
    SSH_ASKPASS = "";
    SSH_ASKPASS_REQUIRE = "never";
    GSM_SKIP_SSH_AGENT_WORKAROUND = "1";
    GCR_SSH_ASKPASS = "";
    DISPLAY_FOR_SSH = "";
  };
}
