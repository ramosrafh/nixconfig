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

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    query-on = {
      url = "path:/home/ramos/git/query-on";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, disko, lanzaboote, niri-flake, llm-agents-nix, ... }@inputs:
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
        inherit nixpkgs home-manager inputs overlays primaryUser system;
      };
    in
    {
      lib.primaryUser = primaryUser;

      nixosConfigurations = {
        desk = mkHost {
          hostName = "desk";
          hostPath = ./hosts/desk;
          homePath = ./hosts/desk/home.nix;
          extraModules = [ niri-flake.nixosModules.niri ];
        };
        book = mkHost {
          hostName = "book";
          hostPath = ./hosts/book;
          homePath = ./hosts/book/home.nix;
          extraModules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            niri-flake.nixosModules.niri
          ];
        };
        server = mkHost {
          hostName = "server";
          hostPath = ./hosts/server;
          nixpkgsInput = nixpkgs-stable;
          extraModules = [
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
          ];
        };
      };

      devShells.${system} = import ./devshells {
        inherit pkgs;
      };

      packages.${system} = {
        disko-install = disko.packages.${system}.disko-install;
        sbctl = pkgs.sbctl;
      };
    };
}
