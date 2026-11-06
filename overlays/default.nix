{ inputs }:
[
  inputs.niri-flake.overlays.niri

  # opencode 2.2.5 in nixpkgs ships a wrong outputHash for its `node_modules`
  # fixed-output derivation, so the build fails with a hash mismatch. Pin the
  # hash this machine actually produces until nixpkgs fixes it upstream.
  (_final: prev: {
    opencode = prev.opencode.overrideAttrs (o: {
      node_modules = o.node_modules.overrideAttrs (_: {
        outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
      });
    });
  })
]
