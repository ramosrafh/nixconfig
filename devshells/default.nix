{ pkgs, pkgs-unfree, lib, ... }:

let
  commonPythonDeps = [
    "ipython"
  ];

  mkPythonShell =
    {
      name,
      python ? pkgs.python314,
      pythonDeps ? commonPythonDeps,
      requirements ? null,
      extraPackages ? [],
      extraBuildInputs ? [],
      jdk ? null,
      javaOpts ? null,
    }:
    let
      generatedRequirements = pkgs.writeText "${name}-requirements.txt" (lib.concatStringsSep "\n" pythonDeps + "\n");
      requirementsFile = if requirements == null then generatedRequirements else requirements;
      requirementsHash =
        if requirements == null
        then builtins.hashString "sha256" (lib.concatStringsSep "\n" pythonDeps)
        else builtins.hashFile "sha256" requirements;
      requirementsInstall = ''
        if [ ! -f "$REQUIREMENTS_MARKER" ] || [ "$(cat "$REQUIREMENTS_MARKER")" != "${requirementsHash}" ]; then
          needs_install=1
        fi

        if [ "$needs_install" = 1 ]; then
          echo "Installing Python requirements for ${name}..."
          uv pip install --python "$VENV_PATH/bin/python" -r "${requirementsFile}"
          echo "${requirementsHash}" > "$REQUIREMENTS_MARKER"
        fi
      '';
    in pkgs.mkShell {
      packages = [ python pkgs.uv ] ++ extraPackages ++ (if jdk != null then [ jdk ] else []);

      buildInputs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        zeromq
      ] ++ extraBuildInputs;

      shellHook = ''
        export UV_PYTHON="${python}/bin/python"
        VENV_BASE="''${XDG_DATA_HOME:-$HOME/.local/share}/venvs"
        VENV_PATH="$VENV_BASE/${name}"
        PYTHON_MARKER="$VENV_PATH/.nix-python-version"
        REQUIREMENTS_MARKER="$VENV_PATH/.nix-requirements-hash"
        needs_install=0

        reset_venv() {
          case "$VENV_PATH" in
            "$VENV_BASE"/*) rm -rf -- "$VENV_PATH" ;;
            *) echo "Unsafe VENV_PATH: $VENV_PATH"; exit 1 ;;
          esac
        }

        mkdir -p "$VENV_BASE"

        if [ ! -x "$VENV_PATH/bin/python" ] \
          || ! "$VENV_PATH/bin/python" -c 'import sys' >/dev/null 2>&1 \
          || [ ! -f "$PYTHON_MARKER" ] \
          || [ "$(cat "$PYTHON_MARKER")" != "${python.pythonVersion}" ]; then
          echo "Creating venv for ${name} with Python ${python.pythonVersion}..."
          reset_venv
          uv venv --python "$UV_PYTHON" "$VENV_PATH"
          echo "${python.pythonVersion}" > "$PYTHON_MARKER"
          needs_install=1
        fi

        ${requirementsInstall}

        unset UV_PYTHON
        export VIRTUAL_ENV="$VENV_PATH"
        export PATH="$VENV_PATH/bin:$PATH"
        export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath ([
          pkgs.stdenv.cc.cc.lib
          pkgs.zlib
          pkgs.zeromq
        ] ++ extraBuildInputs)}:$LD_LIBRARY_PATH"

        ${if jdk != null then ''
          export JAVA_HOME="${jdk}"
          export PATH="$JAVA_HOME/bin:$PATH"
        '' else ""}

        ${if javaOpts != null then ''
          export _JAVA_OPTIONS="${javaOpts}"
        '' else ""}

        exec ${pkgs.fish}/bin/fish
      '';
    };
in
{
  default = mkPythonShell {
    name = "default";
  };

  driva = mkPythonShell {
    name = "driva";
    python = pkgs.python311;
    jdk = pkgs.jdk17;
    extraPackages = [ pkgs-unfree.vscode ];
  };

  flatspot = mkPythonShell {
    name = "flatspot";
  };

  smh = mkPythonShell {
    name = "smh";
  };

  areaseniority = mkPythonShell {
    name = "areaseniority";
    jdk = pkgs.jdk17;
    python = pkgs.python311;
  };

  fatfunc = mkPythonShell {
    name = "fatfunc";
    jdk = pkgs.jdk17;
    python = pkgs.python311;
  };

  economicgroups = mkPythonShell {
    name = "economicgroups";
    jdk = pkgs.jdk17;
    python = pkgs.python314;
    extraPackages = [ pkgs-unfree.vscode ];
  };

  rais = mkPythonShell {
    name = "rais";
    python = pkgs.python311;
    jdk = pkgs.jdk17;
    extraPackages = [ pkgs-unfree.vscode ];
    javaOpts = "-Xms512m -Xmx32g -XX:+UseG1GC -XX:MaxGCPauseMillis=200";
  };

  spark = mkPythonShell {
    name = "spark";
    python = pkgs.python311;
    jdk = pkgs.jdk17;
    extraPackages = [ pkgs-unfree.vscode ];
    javaOpts = "-Xms512m -Xmx32g -XX:+UseG1GC -XX:MaxGCPauseMillis=200";
  };

  cemig = mkPythonShell {
    name = "cemig";
    jdk = pkgs.jdk17;
    python = pkgs.python314;
    extraPackages = [ pkgs-unfree.vscode ];
  };

  tunning = mkPythonShell {
    name = "tunning";
    python = pkgs.python312;
    extraPackages = [ pkgs-unfree.vscode ];
    extraBuildInputs = [ pkgs.zstd ];
  };
}
