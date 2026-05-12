{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs = { self, nixpkgs, home-manager, niri-flake, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });

      overlays = import ./overlays { inherit inputs; };

      mkHost = hostName: hostPath: lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hostPath
          niri-flake.nixosModules.niri
          { nixpkgs.overlays = overlays; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ramos = import ./modules/home;
            home-manager.extraSpecialArgs = { inherit inputs; hostConfig = hostName; };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        desk = mkHost "desk" ./hosts/desk;
        book = mkHost "book" ./hosts/book;
      };

      devShells.${system} = import ./devshells {
        inherit pkgs pkgs-unfree lib;
      };
    };
}
