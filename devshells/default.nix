{ pkgs, ... }:

let
  mkPythonShell =
    {
      name,
      pythonVersion ? "3.14",
      extraPackages ? [],
      extraBuildInputs ? [],
      jdk ? null,
      javaOpts ? null,
      extraShellHook ? "",
    }:
    pkgs.mkShell {
      inherit name;

      packages = [ pkgs.uv ] ++ extraPackages ++ (if jdk == null then [] else [ jdk ]);

      buildInputs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        zeromq
      ] ++ extraBuildInputs;

      shellHook = ''
        export DEV_PYTHON_VERSION="${pythonVersion}"
        export UV_PYTHON_PREFERENCE="only-managed"
        export UV_PYTHON_DOWNLOADS="automatic"
        export UV_PYTHON_INSTALL_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/uv/python"
        export UV_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/uv"

        VENV_BASE="''${XDG_DATA_HOME:-$HOME/.local/share}/venvs"
        project_root="$PWD"
        while [ "$project_root" != "/" ]; do
          if [ -f "$project_root/uv.lock" ] \
            || [ -f "$project_root/pyproject.toml" ] \
            || [ -f "$project_root/requirements.txt" ]; then
            break
          fi
          project_root="$(dirname "$project_root")"
        done

        if [ "$project_root" = "/" ]; then
          project_root=""
          VENV_PATH="$VENV_BASE/${name}"
        else
          VENV_PATH="$project_root/.venv"
        fi

        reset_venv() {
          case "$VENV_PATH" in
            "$VENV_BASE"/*) rm -rf -- "$VENV_PATH" ;;
            "$project_root/.venv") rm -rf -- "$VENV_PATH" ;;
            *) echo "Unsafe VENV_PATH: $VENV_PATH"; return 1 ;;
          esac
        }

        mkdir -p "$VENV_BASE" "$UV_PYTHON_INSTALL_DIR" "$UV_CACHE_DIR"

        if [ -x "$VENV_PATH/bin/python" ]; then
          current_python="$($VENV_PATH/bin/python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null || true)"
          if [ "$current_python" != "$DEV_PYTHON_VERSION" ]; then
            echo "Recreating $VENV_PATH with Python $DEV_PYTHON_VERSION"
            reset_venv
          fi
        fi

        if [ ! -x "$VENV_PATH/bin/python" ]; then
          uv venv --python "$DEV_PYTHON_VERSION" "$VENV_PATH"
        fi

        dependency_marker="$VENV_PATH/.nixconfig-dependencies"
        dependency_hash=""

        if [ -n "$project_root" ] && [ -f "$project_root/uv.lock" ]; then
          dependency_hash="$({ printf '%s\n' "$DEV_PYTHON_VERSION"; sha256sum "$project_root/uv.lock" "$project_root/pyproject.toml"; } | sha256sum | cut -d' ' -f1)"
          if [ ! -f "$dependency_marker" ] || [ "$(cat "$dependency_marker")" != "$dependency_hash" ]; then
            echo "Syncing dependencies from uv.lock"
            (cd "$project_root" && UV_PROJECT_ENVIRONMENT="$VENV_PATH" uv sync --frozen)
            printf '%s\n' "$dependency_hash" > "$dependency_marker"
          fi
        elif [ -n "$project_root" ] && [ -f "$project_root/requirements.txt" ]; then
          dependency_hash="$({
            printf '%s\n' "$DEV_PYTHON_VERSION"
            find "$project_root" -maxdepth 1 -type f -name 'requirements*.txt' -exec sha256sum {} + | sort
            if [ -d "$project_root/requirements" ]; then
              find "$project_root/requirements" -type f -name '*.txt' -exec sha256sum {} + | sort
            fi
          } | sha256sum | cut -d' ' -f1)"
          if [ ! -f "$dependency_marker" ] || [ "$(cat "$dependency_marker")" != "$dependency_hash" ]; then
            echo "Installing dependencies from requirements.txt"
            uv pip install --python "$VENV_PATH/bin/python" -r "$project_root/requirements.txt"
            printf '%s\n' "$dependency_hash" > "$dependency_marker"
          fi
        fi

        export VIRTUAL_ENV="$VENV_PATH"
        export PATH="$VENV_PATH/bin:$PATH"
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath ([
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.zeromq
        ] ++ extraBuildInputs)}:''${LD_LIBRARY_PATH:-}"

        ${if jdk == null then "" else ''
          export JAVA_HOME="${jdk}"
          export PATH="$JAVA_HOME/bin:$PATH"
        ''}

        ${if javaOpts == null then "" else ''
          export _JAVA_OPTIONS="${javaOpts}"
        ''}

        ${extraShellHook}
      '';
    };
in
{
  default = mkPythonShell {
    name = "default";
  };

  node =
    let
      prismaEngines = pkgs.prisma-engines_6;
    in
    pkgs.mkShell {
      name = "node";
      packages = with pkgs; [
        nodejs_22
        openssl
        pkg-config
        prismaEngines
      ];

      shellHook = ''
        export OPENSSL_DIR="${pkgs.openssl.dev}"
        export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.openssl pkgs.stdenv.cc.cc.lib ]}:''${LD_LIBRARY_PATH:-}"
        export PRISMA_SCHEMA_ENGINE_BINARY="${prismaEngines}/bin/schema-engine"
        export PRISMA_QUERY_ENGINE_BINARY="${prismaEngines}/bin/query-engine"
        export PRISMA_QUERY_ENGINE_LIBRARY="${prismaEngines}/lib/libquery_engine.node"
        export PRISMA_FMT_BINARY="${prismaEngines}/bin/prisma-fmt"
        export PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING=1
      '';
    };

  queryon = pkgs.mkShell {
    name = "queryon";
    packages = with pkgs; [
      cargo
      clippy
      rust-analyzer
      rustc
      rustfmt
    ];
  };

  driva = mkPythonShell {
    name = "driva";
    pythonVersion = "3.11";
    jdk = pkgs.jdk17;
    extraShellHook = ''
      kaleido_wrapper="$VIRTUAL_ENV/lib/python3.11/site-packages/kaleido/executable/kaleido"
      if [ -f "$kaleido_wrapper" ] && head -n1 "$kaleido_wrapper" | grep -q '^#!/bin/bash$'; then
        sed -i "1s|^#!/bin/bash$|#!${pkgs.bash}/bin/bash|" "$kaleido_wrapper"
      fi
    '';
  };

  flatspot = mkPythonShell {
    name = "flatspot";
  };

  smh = mkPythonShell {
    name = "smh";
  };

  economicgroups = mkPythonShell {
    name = "economicgroups";
    pythonVersion = "3.14";
    jdk = pkgs.jdk17;
  };

  spark = mkPythonShell {
    name = "spark";
    pythonVersion = "3.11";
    jdk = pkgs.jdk17;
    javaOpts = "-Xms512m -Xmx32g -XX:+UseG1GC -XX:MaxGCPauseMillis=200";
  };
}
