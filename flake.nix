{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

  outputs = { nixpkgs, home-manager, disko, lanzaboote, niri-flake, llm-agents-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      primaryUser = "ramos";
      overlays = import ./overlays { inherit inputs; };
      pkgs = import nixpkgs {
        inherit system;
        inherit overlays;
        config.allowUnfree = true;
      };

      mkHost = hostName: hostPath: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs primaryUser; };
        modules = [
          hostPath
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote
          niri-flake.nixosModules.niri
          { nixpkgs.overlays = overlays; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser} = import ./modules/home;
            home-manager.extraSpecialArgs = {
              inherit inputs primaryUser;
              hostConfig = hostName;
            };
          }
        ];
      };
    in
    {
      inherit primaryUser;

      nixosConfigurations = {
        desk = mkHost "desk" ./hosts/desk;
        book = mkHost "book" ./hosts/book;
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
