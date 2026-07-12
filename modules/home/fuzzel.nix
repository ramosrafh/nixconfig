{ pkgs, ... }:
let
  brokenPine = import ./broken-pine.nix;
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
in {
  home.packages = [
    pkgs.fuzzel
    fuzzel-omnibar
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
