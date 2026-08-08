{ nixpkgs, home-manager, inputs, overlays, primaryUser, system }:
{ hostName, hostPath, homePath ? null, extraModules ? [ ], nixpkgsInput ? nixpkgs }:
nixpkgsInput.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs primaryUser; };

  modules = [
    hostPath
    { nixpkgs.overlays = overlays; }
  ] ++ extraModules ++ nixpkgsInput.lib.optionals (homePath != null) [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${primaryUser} = import homePath;
      home-manager.extraSpecialArgs = {
        inherit inputs primaryUser;
        hostConfig = hostName;
      };
    }
  ];
}
