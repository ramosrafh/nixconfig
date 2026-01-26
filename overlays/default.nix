{ inputs, ... }:
[
  inputs.niri-flake.overlays.niri

  # Override zed-editor to 0.220.6 (fixes Anthropic Claude models in Copilot Chat)
  # Using official prebuilt binary from GitHub releases
  (final: prev: {
    zed-editor = prev.stdenv.mkDerivation rec {
      pname = "zed-editor";
      version = "0.220.6";

      src = prev.fetchzip {
        url = "https://github.com/zed-industries/zed/releases/download/v${version}/zed-linux-x86_64.tar.gz";
        hash = "sha256-fMB8iZ0WI3DZWwkD6Oh481AEy+TQsf/lu47zm68Qcsg=";
        stripRoot = false;
      };

      nativeBuildInputs = [ prev.autoPatchelfHook prev.makeWrapper ];

      buildInputs = with prev; [
        alsa-lib
        fontconfig
        freetype
        libgcc
        libxkbcommon
        openssl
        stdenv.cc.cc.lib
        vulkan-loader
        wayland
        xorg.libxcb
        zlib
      ];

      runtimeDependencies = with prev; [
        vulkan-loader
        libglvnd
        wayland
        xorg.libX11
        xorg.libXcursor
        xorg.libXi
        xorg.libxcb
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/libexec $out/lib $out/share

        # Copy binaries and libs
        cp -r lib/* $out/lib/
        cp libexec/zed-editor $out/libexec/
        cp bin/zed $out/bin/

        # Copy share if exists
        cp -r share/* $out/share/ || true

        # Wrap the main binary with XKB path
        wrapProgram $out/libexec/zed-editor \
          --prefix LD_LIBRARY_PATH : "$out/lib:${prev.lib.makeLibraryPath runtimeDependencies}" \
          --set XKB_CONFIG_ROOT "${prev.xkeyboard_config}/share/X11/xkb"

        # Wrap the launcher
        wrapProgram $out/bin/zed \
          --prefix LD_LIBRARY_PATH : "$out/lib:${prev.lib.makeLibraryPath runtimeDependencies}" \
          --set XKB_CONFIG_ROOT "${prev.xkeyboard_config}/share/X11/xkb"

        runHook postInstall
      '';

      meta = with prev.lib; {
        description = "High-performance, multiplayer code editor";
        homepage = "https://zed.dev";
        license = licenses.gpl3Plus;
        platforms = [ "x86_64-linux" ];
        mainProgram = "zed";
      };
    };
  })
]
