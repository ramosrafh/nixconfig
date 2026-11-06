{ pkgs, ... }:
let
  ante = pkgs.stdenvNoCC.mkDerivation {
    pname = "ante";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url = "https://download.ante.run/releases/v0.3.2/ante-v0.3.2-linux-x86_64-musl.tar.gz";
      hash = "sha256-bJXuJ7BzfCNojono9wTOQuwwOpaCxsW4Ukv9uyUZPKQ=";
    };

    dontUnpack = true;
    installPhase = ''
      tar -xzf "$src"
      install -Dm755 ante "$out/bin/ante"
    '';

    meta.platforms = [ "x86_64-linux" ];
  };
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
    ante
  ];
}
