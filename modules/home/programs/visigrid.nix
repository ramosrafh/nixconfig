{ config, lib, pkgs, ... }:
let
  defaultSettings = pkgs.writeText "visigrid-settings.json" (builtins.toJSON {
    appearance = {
      theme_id = "catppuccin";
    };
  });

  visigrid = pkgs.stdenvNoCC.mkDerivation {
    pname = "visigrid";
    version = "0.30.0";

    src = pkgs.fetchurl {
      url = "https://github.com/VisiGrid/VisiGrid/releases/download/v0.30.0/VisiGrid-linux-x86_64.tar.gz";
      hash = "sha256-gIQ4zhnhaK6aa8zOwSUfs6L4osykuxlYX7GLB8+pTrw=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = with pkgs; [
      dbus
      libGL
      libxkbcommon
      stdenv.cc.cc.lib
      libxcb
      vulkan-loader
      wayland
      zlib
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 visigrid $out/bin/visigrid
      install -Dm755 vgrid $out/bin/vgrid
      install -Dm644 visigrid.desktop $out/share/applications/visigrid.desktop
      install -Dm644 visigrid.png $out/share/icons/hicolor/256x256/apps/visigrid.png

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/visigrid \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath [
            pkgs.libGL
            pkgs.vulkan-loader
            pkgs.wayland
          ]
        }
    '';

    meta = {
      description = "Fast, keyboard-driven spreadsheet";
      homepage = "https://github.com/VisiGrid/VisiGrid";
      license = pkgs.lib.licenses.asl20;
      mainProgram = "visigrid";
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  home.packages = [ visigrid ];

  home.activation.setVisigridDefaultTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_dir="${config.home.homeDirectory}/.config/visigrid"
    settings_file="$settings_dir/settings.json"
    ${pkgs.coreutils}/bin/mkdir -p "$settings_dir"

    if ! test -s "$settings_file"; then
      ${pkgs.coreutils}/bin/install -m 600 ${defaultSettings} "$settings_file"
    fi
  '';
}
