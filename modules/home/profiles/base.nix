{ pkgs, inputs, ... }:
let
  goose-cli = builtins.fetchClosure {
    fromStore = "https://cache.numtide.com";
    fromPath = inputs.llm-agents-nix.packages."${pkgs.stdenv.hostPlatform.system}".goose-cli;
    inputAddressed = true;
  };
in {
  imports = [
    ../programs/fish.nix
    ../programs/git.nix
    ../programs/helix.nix
    ../programs/opencode.nix
    ../programs/ssh.nix
    ../programs/yazi.nix
    ../programs/zellij.nix
  ];

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    inputs.query-on.packages."${pkgs.stdenv.hostPlatform.system}".default
    goose-cli
    claude-code
    bottom
    awscli
    unzip
    codex
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
