{ pkgs, ... }:
let
  brokenPine = import ../themes/broken-pine.nix;
  fuzzel-omnibar = pkgs.writeShellApplication {
    name = "fuzzel-omnibar";
    runtimeInputs = with pkgs; [
      coreutils
      fuzzel
      gnugrep
      gnused
      python3
      xdg-utils
    ];
    text = ''
      urlencode() {
        python3 -c 'import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))' "$1"
      }

      command="search"

      while [ "$#" -gt 0 ]; do
        case "$1" in
          --command=*)
            command="''${1#--command=}"
            ;;
          --command)
            shift
            command="''${1:-search}"
            ;;
        esac
        shift || true
      done

      case "$command" in
        search) ;;
        *)
          echo "Unsupported command: $command" >&2
          exit 2
          ;;
      esac

      query="$(
        printf '\n' | fuzzel --dmenu --prompt-only "" --placeholder "URL ou busca..." --lines 0
      )"

      query="$(printf '%s' "$query" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
      [ -n "$query" ] || exit 0

      cnpj_digits="$(printf '%s' "$query" | tr -cd '0-9')"

      if printf '%s' "$query" | grep -Eiq '^(nix|pkg|package) +'; then
        package_query="$(printf '%s' "$query" | sed -E 's/^(nix|pkg|package)[[:space:]]+//I')"
        encoded="$(urlencode "package $package_query")"
        target="https://mynixos.com/search?q=$encoded"
      elif printf '%s' "$query" | grep -Eiq '^cnpj +' && [ "''${#cnpj_digits}" -eq 14 ]; then
        target="https://datahub.kipflow.io/cnpj/$cnpj_digits"
      elif [ "''${#cnpj_digits}" -eq 14 ] && printf '%s' "$query" | grep -Eq '^[0-9./ -]+$'; then
        target="https://datahub.kipflow.io/cnpj/$cnpj_digits"
      elif printf '%s' "$query" | grep -Eq '^[A-Za-z][A-Za-z0-9+.-]*://'; then
        target="$query"
      elif printf '%s' "$query" | grep -Eq '^localhost(:[0-9]+)?(/.*)?$'; then
        target="http://$query"
      elif printf '%s' "$query" | grep -Eq '^([[:alnum:]-]+\.)+[[:alpha:]]{2,}(:[0-9]+)?(/.*)?$'; then
        target="https://$query"
      else
        encoded="$(urlencode "$query")"
        target="https://www.google.com/search?q=$encoded"
      fi

      xdg-open "$target" >/dev/null 2>&1 &
    '';
  };

  fuzzel-window-switcher = pkgs.writeShellApplication {
    name = "fuzzel-window-switcher";
    runtimeInputs = with pkgs; [
      fuzzel
      jq
      niri-unstable
    ];
    text = ''
      resolve_icon() {
        local app_id="$1"
        local data_dir desktop_file line icon
        local -a data_dirs

        IFS=: read -r -a data_dirs <<< "''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

        if [[ "$app_id" != */* ]]; then
          for data_dir in "''${data_dirs[@]}"; do
            desktop_file="$data_dir/applications/$app_id.desktop"
            [ -r "$desktop_file" ] || continue

            while IFS= read -r line; do
              case "$line" in
                Icon=*)
                  icon="''${line#Icon=}"
                  [ -n "$icon" ] && printf '%s\n' "$icon" && return
                  ;;
              esac
            done < "$desktop_file"
          done
        fi

        printf '%s\n' "$app_id"
      }

      windows="$(niri msg --json windows)"
      workspaces="$(niri msg --json workspaces)"
      icons='{}'

      while IFS= read -r app_id; do
        icon="$(resolve_icon "$app_id")"
        icons="$(
          jq --compact-output \
            --arg app_id "$app_id" \
            --arg icon "$icon" \
            '. + {($app_id): $icon}' \
            <<< "$icons"
        )"
      done < <(jq --raw-output 'map(.app_id // empty) | unique[]' <<< "$windows")

      window_id="$(
        jq --raw-output \
          --argjson workspaces "$workspaces" \
          --argjson icons "$icons" \
          '
          sort_by(.focus_timestamp // { secs: 0, nanos: 0 })
          | reverse
          | .[] as $window
          | ($workspaces | map(select(.id == $window.workspace_id)) | .[0]) as $workspace
          | (if $workspace == null then "?" else ($workspace.name // ($workspace.idx | tostring)) end) as $workspace_label
          | (($window.app_id // "Aplicativo") | gsub("[\\t\\r\\n]+"; " ")) as $app_id
          | (($window.title // "Sem título") | gsub("[\\t\\r\\n]+"; " ")) as $title
          | (($icons[$app_id] // $app_id) | gsub(","; "")) as $icon
          | ($window.id | tostring)
            + "\t"
            + $workspace_label
            + "  ·  "
            + $app_id
            + "  —  "
            + $title
            + "\u0000icon\u001f"
            + $icon
            + ",application-x-executable"
          ' <<< "$windows" \
          | fuzzel \
              --dmenu \
              --only-match \
              --with-nth=2 \
              --match-nth=2 \
              --accept-nth=1 \
              --match-mode=fuzzy \
              --no-run-if-empty \
              --prompt="Janelas  " \
              --placeholder="Buscar janela..."
      )" || exit 0

      [ -n "$window_id" ] || exit 0

      niri msg action focus-window --id "$window_id"
    '';
  };
in {
  home.packages = [
    pkgs.fuzzel
    fuzzel-omnibar
    fuzzel-window-switcher
  ];

  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [main]
    font=Inter:size=14:weight=medium
    icon-theme=Papirus-Dark
    icons-enabled=yes
    image-size-ratio=0.5
    lines=8
    width=45
    horizontal-pad=20
    vertical-pad=12
    inner-pad=8
    line-height=28
    letter-spacing=0.5
    layer=overlay
    prompt="  "
    placeholder=Buscar...

    [border]
    width=2
    radius=0

    [colors]
    # Broken Pine
    background=${brokenPine.withAlpha brokenPine.background "f2"}
    text=${brokenPine.withAlpha brokenPine.text "ff"}
    prompt=${brokenPine.withAlpha brokenPine.blue "ff"}
    placeholder=${brokenPine.withAlpha brokenPine.placeholder "ff"}
    input=${brokenPine.withAlpha brokenPine.text "ff"}
    match=${brokenPine.withAlpha brokenPine.blue "ff"}
    selection=${brokenPine.withAlpha brokenPine.surfaceActive "ff"}
    selection-text=${brokenPine.withAlpha brokenPine.textAlt "ff"}
    selection-match=${brokenPine.withAlpha brokenPine.orange "ff"}
    counter=${brokenPine.withAlpha brokenPine.mutedAlt "ff"}
    border=${brokenPine.withAlpha brokenPine.borderFocused "80"}
  '';
}
