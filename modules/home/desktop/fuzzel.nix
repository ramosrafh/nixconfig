{ pkgs, ... }:
let
  vesper = import ../themes/vesper.nix;
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

  fuzzel-clipboard = pkgs.writeShellApplication {
    name = "fuzzel-clipboard";
    runtimeInputs = with pkgs; [
      cliphist
      fuzzel
      wl-clipboard
    ];
    text = ''
      clear_action="󰆴  Limpar histórico"

      selection="$({
        printf '%s\n' "$clear_action"
        cliphist list
      } | fuzzel \
        --dmenu \
        --prompt="Clipboard  " \
        --placeholder="Buscar no histórico..." \
        --lines=12 \
        --width=52
      )" || exit 0

      [ -n "$selection" ] || exit 0

      if [ "$selection" = "$clear_action" ]; then
        confirmation="$(
          printf '%s\n' "Cancelar" "Limpar histórico" \
            | fuzzel --dmenu --prompt="Confirmar  " --lines=2 --width=28
        )" || exit 0

        [ "$confirmation" = "Limpar histórico" ] && cliphist wipe
        exit 0
      fi

      printf '%s' "$selection" | cliphist decode | wl-copy
    '';
  };

  fuzzel-power-menu = pkgs.writeShellApplication {
    name = "fuzzel-power-menu";
    runtimeInputs = with pkgs; [
      fuzzel
      hyprlock
      niri-unstable
      systemd
    ];
    text = ''
      lock_action="󰌾  Bloquear"
      logout_action="󰍃  Encerrar sessão"
      reboot_action="󰜉  Reiniciar"
      poweroff_action="󰐥  Desligar"

      action="$(
        printf '%s\n' \
          "$lock_action" \
          "$logout_action" \
          "$reboot_action" \
          "$poweroff_action" \
          | fuzzel --dmenu --prompt="Power  " --lines=4 --width=30
      )" || exit 0

      confirm_action() {
        local label="$1"
        local confirmation

        confirmation="$(
          printf '%s\n' "Cancelar" "$label" \
            | fuzzel --dmenu --prompt="Confirmar  " --lines=2 --width=28
        )" || return 1

        [ "$confirmation" = "$label" ]
      }

      case "$action" in
        "$lock_action")
          hyprlock
          ;;
        "$logout_action")
          niri msg action quit
          ;;
        "$reboot_action")
          confirm_action "$reboot_action" && systemctl reboot
          ;;
        "$poweroff_action")
          confirm_action "$poweroff_action" && systemctl poweroff
          ;;
      esac
    '';
  };
in
{
  services.cliphist = {
    enable = true;
    allowImages = false;
    extraOptions = [
      "-max-dedupe-search"
      "50"
      "-max-items"
      "500"
    ];
  };

  home.packages = [
    pkgs.fuzzel
    fuzzel-omnibar
    fuzzel-window-switcher
    fuzzel-clipboard
    fuzzel-power-menu
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
    # Vesper
    background=${vesper.withAlpha vesper.background "f2"}
    text=${vesper.withAlpha vesper.text "ff"}
    prompt=${vesper.withAlpha vesper.blue "ff"}
    placeholder=${vesper.withAlpha vesper.placeholder "ff"}
    input=${vesper.withAlpha vesper.text "ff"}
    match=${vesper.withAlpha vesper.blue "ff"}
    selection=${vesper.withAlpha vesper.surfaceActive "ff"}
    selection-text=${vesper.withAlpha vesper.textAlt "ff"}
    selection-match=${vesper.withAlpha vesper.orange "ff"}
    counter=${vesper.withAlpha vesper.mutedAlt "ff"}
    border=${vesper.withAlpha vesper.borderFocused "80"}
  '';
}
