{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: 
    let
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });
    in {
      nixosConfigurations = {
        desk = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desk
            niri.nixosModules.niri
            {
              nixpkgs.overlays = [ niri.overlays.niri ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ramos = import ./modules/home;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [ niri.homeModules.niri ];
            }
          ];
        };
      };
    };
}
