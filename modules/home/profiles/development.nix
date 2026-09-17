{ pkgs, inputs, ... }:
let
  herdr = inputs.llm-agents-nix.packages."${pkgs.stdenv.hostPlatform.system}".herdr;
  ante = pkgs.stdenvNoCC.mkDerivation {
    pname = "ante";
    version = "0.preview.99";

    src = pkgs.fetchurl {
      url = "https://download.ante.run/releases/v0.preview.99/ante-v0.preview.99-linux-x86_64-musl.tar.gz";
      hash = "sha256-8mmOvzTVQzWuaMVCEJ9ihlr7X80fcOLtKdTqYKGNyMY=";
    };

    dontUnpack = true;
    installPhase = ''
      tar -xzf "$src"
      install -Dm755 ante "$out/bin/ante"
    '';

    meta.platforms = [ "x86_64-linux" ];
  };
  # goose-cli = builtins.fetchClosure {
  #   fromStore = "https://cache.numtide.com";
  #   fromPath = inputs.llm-agents-nix.packages."${pkgs.stdenv.hostPlatform.system}".goose-cli;
  #   inputAddressed = true;
  # };
in
{
  imports = [
    ./cli.nix
    ../programs/ante.nix
    ../programs/herdr.nix
    ../programs/opencode.nix
  ];

  home.packages = with pkgs; [
    goose-cli
    claude-code
    awscli2
    codex
    herdr
    ante
  ];
}
