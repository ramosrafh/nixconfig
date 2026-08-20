{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      # url = "github:sodiboo/niri-flake";
      # TODO: change this back after associated PR is merged: https://github.com/sodiboo/niri-flake/pull/1850
      url = "github:sodiboo/niri-flake?rev=6bb99ff875919f03ea6054026619d999061e1170";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      disko,
      lanzaboote,
      sops-nix,
      niri-flake,
      llm-agents-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      primaryUser = "ramos";
      overlays = import ./overlays { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };

      mkHost = import ./lib/mk-host.nix {
        inherit
          nixpkgs
          home-manager
          primaryUser
          system
          ;
      };
    in
    {
      lib.primaryUser = primaryUser;

      nixosConfigurations = {
        desk = mkHost {
          hostPath = ./hosts/desk;
          homePath = ./hosts/desk/home.nix;
          hostOverlays = overlays;
          homeExtraSpecialArgs = { inherit inputs; };
          extraModules = [ niri-flake.nixosModules.niri ];
        };
        book = mkHost {
          hostPath = ./hosts/book;
          homePath = ./hosts/book/home.nix;
          hostOverlays = overlays;
          homeExtraSpecialArgs = { inherit inputs; };
          extraModules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            niri-flake.nixosModules.niri
          ];
        };
        server = mkHost {
          hostPath = ./hosts/server;
          nixpkgsInput = nixpkgs-stable;
          # syswatch is not available in stable; expose only this package from
          # the already pinned unstable package set.
          hostOverlays = [
            (_final: _prev: { inherit (pkgs) syswatch; })
          ];
          extraModules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            sops-nix.nixosModules.sops
          ];
        };
      };

      devShells.${system} = import ./devshells {
        inherit pkgs;
      };

      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system} = {
        disko-install = disko.packages.${system}.disko-install;
        sbctl = pkgs.sbctl;
      };
    };
}
