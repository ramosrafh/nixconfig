{ pkgs, inputs, ... }:
let
  # goose-cli = builtins.fetchClosure {
  #   fromStore = "https://cache.numtide.com";
  #   fromPath = inputs.llm-agents-nix.packages."${pkgs.stdenv.hostPlatform.system}".goose-cli;
  #   inputAddressed = true;
  # };
in
{
  imports = [
    ./cli.nix
    ../programs/opencode.nix
  ];

  home.packages = with pkgs; [
    goose-cli
    claude-code
    awscli
    codex
  ];
}
