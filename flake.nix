{
  description = "NixOS configuration with flakes";

  # Inputs
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window Manager
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Outputs
  outputs = { self, nixpkgs, home-manager, niri-flake, ... }@inputs:
    let
      # System configuration
      system = "x86_64-linux";

      # Extended library with custom functions
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });

      # Overlays
      overlays = import ./overlays { inherit inputs; };

      # Common modules shared between hosts
      commonModules = [
        niri-flake.nixosModules.niri
        { nixpkgs.overlays = overlays; }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ramos = import ./modules/home;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];

      # Helper function to create host configuration
      mkHost = hostPath: lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ hostPath ] ++ commonModules;
      };
    in
    {
      # NixOS Configurations
      nixosConfigurations = {
        desk = mkHost ./hosts/desk;
        book = mkHost ./hosts/book;
      };
    };
}
