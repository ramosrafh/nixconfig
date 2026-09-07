{ lib, pkgs, ... }:
let
  vesper = import ../themes/vesper.nix;
  workspaceIndexes = map toString (lib.range 1 9);

  niriWorkspace = pkgs.writeShellApplication {
    name = "waybar-niri-workspace";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      niri-unstable
      util-linux
    ];
    text = ''
      workspace_index="$1"
      output_name="''${WAYBAR_OUTPUT_NAME:-}"
      state_dir="''${XDG_RUNTIME_DIR:-/tmp/waybar-$UID}"
      state_file="$state_dir/niri-workspaces.json"
      timestamp_file="$state_dir/niri-workspaces.timestamp"
      lock_file="$state_dir/niri-workspaces.lock"

      mkdir -p "$state_dir"
      chmod 700 "$state_dir"
      exec 9>"$lock_file"
      flock 9

      now="$(date +%s%3N)"
      state_timestamp=0
      if [ -f "$timestamp_file" ]; then
        state_timestamp="$(<"$timestamp_file")"
      fi

      if [ ! -f "$state_file" ] || [ "$((now - state_timestamp))" -ge 75 ]; then
        windows="$(niri msg --json windows 2>/dev/null || printf '[]')"
        workspaces="$(niri msg --json workspaces 2>/dev/null || printf '[]')"
        jq --compact-output --null-input \
          --argjson windows "$windows" \
          --argjson workspaces "$workspaces" \
          '{ windows: $windows, workspaces: $workspaces }' \
          > "$state_file.tmp"
        mv "$state_file.tmp" "$state_file"
        printf '%s\n' "$now" > "$timestamp_file"
      fi

      state="$(<"$state_file")"
      flock --unlock 9

      jq --compact-output --null-input \
        --argjson state "$state" \
        --argjson index "$workspace_index" \
        --arg output "$output_name" \
        '
          def app_icon:
            ascii_downcase as $app
            | if $app | test("firefox|librewolf|floorp|zen") then "<span foreground=\"#ff7139\">󰈹</span>"
              elif $app | test("chromium|chrome|brave|vivaldi") then "<span foreground=\"#4285f4\"></span>"
              elif $app | test("alacritty|kitty|foot|wezterm|ghostty|terminal") then "<span foreground=\"${vesper.yellow}\"></span>"
              elif $app | test("code|codium") then "<span foreground=\"#23a8f2\">󰨞</span>"
              elif $app | test("zed") then "<span foreground=\"#f2f2f2\">󰅩</span>"
              elif $app | test("nautilus|thunar|pcmanfm|dolphin") then "<span foreground=\"#f9e2af\">󰉋</span>"
              elif $app | test("discord|vesktop|legcord") then "<span foreground=\"#5865f2\">󰙯</span>"
              elif $app | test("telegram") then "<span foreground=\"#229ed9\"></span>"
              elif $app | test("signal") then "<span foreground=\"#3a76f0\">󰭹</span>"
              elif $app | test("slack") then "<span foreground=\"#e01e5a\"></span>"
              elif $app | test("spotify") then "<span foreground=\"#1db954\"></span>"
              elif $app | test("steam") then "<span foreground=\"#66c0f4\"></span>"
              elif $app | test("obsidian") then "<span foreground=\"#a88bfa\">󰎚</span>"
              elif $app | test("query-on") then "<span foreground=\"#89b4fa\">󰆼</span>"
              elif $app | test("mpv|vlc|celluloid") then "<span foreground=\"#f38ba8\">󰕼</span>"
              elif $app | test("pavucontrol|easyeffects") then "<span foreground=\"#cba6f7\">󰕾</span>"
              elif $app | test("org.gnome.calculator|qalculate") then "<span foreground=\"#fab387\">󰪚</span>"
              else "<span foreground=\"#bac2de\"></span>"
              end;

          def markup_escape:
            gsub("&"; "&amp;")
            | gsub("<"; "&lt;")
            | gsub(">"; "&gt;");

          (
            $state.workspaces
            | map(select(.idx == $index and ($output == "" or .output == $output)))
            | if length == 0 and $output == "" then
                ($state.workspaces | map(select(.idx == $index and (.is_focused or .is_active))) | .[0])
              else .[0]
              end
          ) as $workspace
          | if $workspace == null then
              { text: "", tooltip: "", class: ["hidden"] }
            else
              ($state.windows
                | map(select(.workspace_id == $workspace.id))
                | sort_by([
                    (.layout.pos_in_scrolling_layout[0] // 999999),
                    (.layout.pos_in_scrolling_layout[1] // 999999)
                  ])) as $workspace_windows
              | (
                  $workspace_windows
                  | map({
                      icon: ((.app_id // "") | app_icon | gsub("<span "; "<span size=\"medium\" ")),
                      focused: .is_focused
                    })
                  | reduce .[] as $app ([ ];
                      if any(.[]; .icon == $app.icon) then
                        map(if .icon == $app.icon then .focused = (.focused or $app.focused) else . end)
                      else . + [$app]
                      end
                    )
                ) as $app_icons
              | ($app_icons | .[0:3]) as $visible_icons
              | (($app_icons | length) - ($visible_icons | length)) as $extra_icon_count
              | (
                  $visible_icons
                  | map(
                      if .focused then .icon
                      else (.icon | gsub("<span "; "<span alpha=\"40%\" "))
                      end
                    )
                ) as $icons
              | {
                  text: (
                    ($workspace.idx | tostring)
                    + if ($icons | length) > 0 then " " + ($icons | join(" ")) else "" end
                    + if $extra_icon_count > 0 then " <span size=\"small\">+" + ($extra_icon_count | tostring) + "</span>" else "" end
                  ),
                  tooltip: (
                    if ($workspace_windows | length) == 0 then "Workspace vazio"
                    else ($workspace_windows | map((.title // .app_id // "Janela") | markup_escape) | join("\n"))
                    end
                  ),
                  class: (
                    [
                      (if $workspace.is_focused then "focused" else empty end),
                      (if $workspace.is_active then "active" else empty end),
                      (if $workspace.is_urgent then "urgent" else empty end),
                      (if ($workspace_windows | length) == 0 then "empty" else empty end)
                    ]
                  )
                }
            end
        '
    '';
  };

  niriWorkspaceEvents = pkgs.writeShellApplication {
    name = "waybar-niri-workspace-events";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      niri-unstable
    ];
    text = ''
      waybar_pid="$PPID"
      printf '\n'

      # The bounded stream prevents orphan listeners after a Waybar restart.
      # It is renewed only every 30 seconds while its parent is alive.
      while kill -0 "$waybar_pid" 2>/dev/null; do
        timeout 30 niri msg --json event-stream \
          | jq --unbuffered --raw-output \
            'select(
              has("WorkspaceActivated")
              or has("WorkspacesChanged")
              or has("WindowClosed")
              or has("WindowFocusChanged")
              or (
                has("WindowOpenedOrChanged")
                and ((.WindowOpenedOrChanged.window.title // "") | test("^[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏] ") | not)
              )
            ) | "refresh"' \
          | while IFS= read -r _; do
              kill -s RTMIN+8 "$waybar_pid" 2>/dev/null || true
            done
      done
    '';
  };

  # Niri's native window module redraws on every title update (for example,
  # Codex's spinner). Polling the focused window at a modest rate keeps the
  # bar responsive without the redraw storm.
  niriWindow = pkgs.writeShellApplication {
    name = "waybar-niri-window";
    runtimeInputs = with pkgs; [
      jq
      niri-unstable
    ];
    text = ''
      window="$(niri msg --json focused-window 2>/dev/null || printf 'null')"

      jq --compact-output --null-input \
        --argjson window "$window" \
        '
          def markup_escape:
            gsub("&"; "&amp;")
            | gsub("<"; "&lt;")
            | gsub(">"; "&gt;");

          if $window == null then
            { text: "", class: ["empty"] }
          else
            (($window.title // "")
              | sub("^[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏] "; "")
              | markup_escape) as $title
            | { text: $title, class: [($window.app_id // "unknown" | ascii_downcase)] }
          end
        '
    '';
  };

  workspaceModules = builtins.listToAttrs (
    map (index: {
      name = "custom/niri-workspace#${index}";
      value = {
        exec = "${niriWorkspace}/bin/waybar-niri-workspace ${index}";
        return-type = "json";
        interval = 10;
        signal = 8;
        hide-empty-text = true;
        escape = false;
        on-click = "niri msg action focus-workspace ${index}";
        tooltip = true;
      };
    }) workspaceIndexes
  );
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = workspaceModules // {
        layer = "top";
        position = "top";
        height = 36;
        margin-top = 6;
        modules-left = [
          "clock"
        ]
        ++ map (index: "custom/niri-workspace#${index}") workspaceIndexes
        ++ [ "custom/niri-workspace-events" ];
        modules-center = [ "custom/niri-window" ];
        modules-right = [
          "tray"
          "custom/mem"
          "custom/netbird-profile"
          "network"
          "backlight"
          "pulseaudio"
          # "pulseaudio#source" # Microfone desativado na Waybar.
          "battery"
        ];

        "custom/niri-window" = {
          exec = "${niriWindow}/bin/waybar-niri-window";
          return-type = "json";
          interval = 2;
          max-length = 80;
          escape = false;
          tooltip = false;
        };

        "custom/niri-workspace-events" = {
          exec = "${niriWorkspaceEvents}/bin/waybar-niri-workspace-events";
          restart-interval = 1;
          hide-empty-text = true;
          tooltip = false;
        };

        tray = {
          icon-size = 16;
          spacing = 10;
        };

        backlight = {
          format = "{icon}  {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          min-length = 6;
        };

        "custom/mem" = {
          format = "  {}";
          interval = 3;
          exec = "free -h | awk '/Mem:/{printf $3}'";
          tooltip = false;
        };

        "custom/netbird-profile" = {
          exec = "netbird-profile waybar";
          format = "󰒄";
          interval = 5;
          hide-empty-text = true;
          tooltip = false;
          on-click = "netbird-profile toggle";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-alt = "{time}  {icon}";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%R %A, %B %d, %Y}";
          tooltip-format = "<big>{calendar}</big>";
        };

        network = {
          format-wifi = "󰤨  {essid}";
          format-ethernet = "󰒍 {essid}";
          format-linked = "󰲛 {ifname}";
          format-disconnected = "󰤭  Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " ";
          scroll-step = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          format-icons = {
            headphone = "󰋋";
            hands-free = "";
            headset = "󰋋";
            phone = "";
            portable = "";
            car = "";
            default = [
              " "
              " "
              " "
            ];
          };
        };

        # "pulseaudio#source" = {
        #   format = "{format_source}";
        #   format-source = "󰍬 {volume}%";
        #   format-source-muted = "";
        #   on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        #   on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
        #   on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
        # };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Symbols Nerd Font Mono", "Material Design Icons", monospace;
        font-weight: bold;
        font-size: 16px;
        border-radius: 0px;
      }

      window#waybar {
        background-color: transparent;
        color: ${vesper.text};
      }

      .modules-left {
        margin-left: 10px;
      }

      .modules-right {
        margin-right: 10px;
      }

      #battery,
      #network,
      #pulseaudio,
      #backlight,
      #custom-netbird-profile,
      #tray,
      #clock {
        color: ${vesper.text};
        background-color: transparent;
        margin: 0px;
        padding: 2px 7px;
      }

      #clock {
        color: ${vesper.text};
        background-color: transparent;
        border-radius: 4px;
        margin-left: 0px;
      }

      #network {
        color: ${vesper.text};
        border-radius: 4px 0px 0px 4px;
      }

      #battery {
        color: ${vesper.text};
        border-radius: 0px 4px 4px 0px;
      }

      #pulseaudio {
        color: ${vesper.text};
      }

      #backlight {
        color: ${vesper.text};
      }

      #custom-niri-workspace {
        background-color: transparent;
        color: ${vesper.muted};
        margin: 2px 0 2px 18px;
        padding: 0 2px;
        border-radius: 0px;
        box-shadow: none;
        min-height: 28px;
      }

      #clock + #custom-niri-workspace {
        margin-left: 10px;
      }

      #custom-niri-workspace label {
        font-size: 16px;
      }

      #custom-niri-window {
        font-size: 14px;
        color: ${vesper.text};
        background-color: transparent;
        padding: 0px;
        border-radius: 0px;
      }

      #custom-niri-workspace.active,
      #custom-niri-workspace.focused {
        background-color: transparent;
        color: ${vesper.text};
        box-shadow: inset 0 -2px ${vesper.yellow};
      }

      #custom-niri-workspace.urgent {
        color: ${vesper.red};
      }

      #custom-mem {
        color: ${vesper.text};
        margin: 0px;
        margin-right: 6px;
        padding: 0px 7px;
        background-color: transparent;
        border-radius: 4px;
      }

      #custom-netbird-profile {
        color: ${vesper.text};
        margin: 0px;
        margin-right: 2px;
        padding: 0px 6px;
        background-color: transparent;
        border-radius: 4px;
      }

      #custom-niri-workspace:hover {
        background-color: transparent;
        color: ${vesper.muted};
        box-shadow: none;
      }

      #custom-niri-window.empty {
        background-color: transparent;
        padding: 0px;
      }

      #tray {
        margin: 0px;
        margin-right: 6px;
        padding: 0px 7px;
        background-color: transparent;
        border-radius: 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: none;
      }
    '';
  };
}
