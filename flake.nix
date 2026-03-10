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
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unfree = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Extended library with custom functions
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; lib = self; };
      });

      # Overlays
      overlays = import ./overlays { inherit inputs; };

      # Helper function to create host configuration
      mkHost = hostName: hostPath: lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hostPath
          niri-flake.nixosModules.niri
          { nixpkgs.overlays = overlays; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ramos = import ./modules/home;
            home-manager.extraSpecialArgs = { inherit inputs; hostConfig = hostName; };
          }
        ];
      };
    in
    {
      # NixOS Configurations
      nixosConfigurations = {
        desk = mkHost "desk" ./hosts/desk;
        book = mkHost "book" ./hosts/book;
      };

      devShells.${system} = let
        mkPythonShell = { name, python ? pkgs.python314, extraPackages ? [], jdk ? null }: pkgs.mkShell {
          packages = [ python pkgs.uv ] ++ extraPackages ++ (if jdk != null then [ jdk ] else []);

          buildInputs = with pkgs; [
            stdenv.cc.cc.lib
            zlib
            zeromq
          ];

          shellHook = ''
            export UV_PYTHON="${python}/bin/python"
            VENV_PATH="''${XDG_DATA_HOME:-$HOME/.local/share}/venvs/${name}"
            PYTHON_MARKER="$VENV_PATH/.nix-python-path"
            mkdir -p "$(dirname "$VENV_PATH")"

            # Recreate venv if it doesn't exist or if Python path has changed
            if [ ! -d "$VENV_PATH" ] || [ ! -f "$PYTHON_MARKER" ] || [ "$(cat "$PYTHON_MARKER")" != "${python}" ]; then
              echo "Creating/recreating venv for ${name} with ${python}..."
              rm -rf "$VENV_PATH"
              uv venv "$VENV_PATH"
              echo "${python}" > "$PYTHON_MARKER"
            fi

            unset UV_PYTHON
            export VIRTUAL_ENV="$VENV_PATH"
            export PATH="$VENV_PATH/bin:$PATH"
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.stdenv.cc.cc.lib
              pkgs.zlib
              pkgs.zeromq
            ]}:$LD_LIBRARY_PATH"

            ${if jdk != null then ''
              export JAVA_HOME="${jdk}"
              export PATH="$JAVA_HOME/bin:$PATH"
            '' else ""}

            exec ${pkgs.fish}/bin/fish
          '';
        };
      in {
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
          # extraPackages = with pkgs.python314Packages; [
          #   ipykernel
          #   pyzmq
          # ];
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

        cemig= mkPythonShell {
          name = "cemig";
          jdk = pkgs.jdk17;
          python = pkgs.python314;
          extraPackages = [ pkgs-unfree.vscode ];
        };
      };
    };
}
