{ pkgs, ... }:
let
  netbird-profile = pkgs.writeShellApplication {
    name = "netbird-profile";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      libnotify
      netbird
    ];
    text = ''
      active_profile() {
        awk 'NR > 1 && $NF == "✓" { $NF = ""; sub(/[[:space:]]+$/, ""); print; exit }'
      }

      profile_named() {
        awk -v wanted="$1" '
          NR > 1 {
            if ($NF == "✓") $NF = ""
            sub(/[[:space:]]+$/, "")
            if (tolower($0) == wanted) { print; exit }
          }
        '
      }

      case "''${1:-active}" in
        active)
          current="$(timeout 2s netbird profile list 2>/dev/null | active_profile || true)"
          printf '%s\n' "''${current:-Indisponível}"
          ;;
        toggle)
          available="$(netbird profile list)" || {
            notify-send --urgency=critical "NetBird" "Não foi possível consultar os perfis."
            exit 1
          }
          current="$(printf '%s\n' "$available" | active_profile)"

          case "$(printf '%s' "$current" | tr '[:upper:]' '[:lower:]')" in
            driva) wanted="homelab" ;;
            homelab) wanted="driva" ;;
            *)
              notify-send --urgency=normal "NetBird" "Perfil ativo: ''${current:-nenhum}. Esperados: Driva e Homelab."
              exit 1
              ;;
          esac

          target="$(printf '%s\n' "$available" | profile_named "$wanted")"
          if [ -z "$target" ]; then
            notify-send --urgency=critical "NetBird" "Perfil '$wanted' não encontrado."
            exit 1
          fi

          netbird profile select "$target" >/dev/null
          netbird up >/dev/null
          notify-send --urgency=normal "NetBird" "Perfil ativo: $target"
          ;;
        *)
          printf 'Uso: netbird-profile [active|toggle]\n' >&2
          exit 2
          ;;
      esac
    '';
  };
in
{
  home.packages = [ netbird-profile ];
}
