{
  nixpkgs,
  home-manager,
  primaryUser,
  system,
}:
{
  hostPath,
  homePath ? null,
  extraModules ? [ ],
  hostOverlays ? [ ],
  homeExtraSpecialArgs ? { },
  nixpkgsInput ? nixpkgs,
}:
nixpkgsInput.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit primaryUser; };

  modules = [
    hostPath
    { nixpkgs.overlays = hostOverlays; }
  ]
  ++ extraModules
  ++ nixpkgsInput.lib.optionals (homePath != null) [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${primaryUser} = import homePath;
      home-manager.extraSpecialArgs = {
        inherit primaryUser;
      }
      // homeExtraSpecialArgs;
    }
  ];
}
