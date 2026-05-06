{ inputs, ... }:
[
  inputs.niri-flake.overlays.niri

  (final: prev: {
    niri = prev.niri.overrideAttrs (old: {
      doCheck = false;
    });
  })
]
