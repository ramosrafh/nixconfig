{ lib, pkgs, ... }:
let
  brokenPine = import ../themes/broken-pine.nix;
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
              elif $app | test("alacritty|kitty|foot|wezterm|ghostty|terminal") then "<span foreground=\"${brokenPine.blue}\"></span>"
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
              ($state.windows | map(select(.workspace_id == $workspace.id))) as $workspace_windows
              | ($workspace_windows | map((.app_id // "") | app_icon) | unique | .[0:3]) as $app_icons
              | (
                  if $workspace.is_focused or $workspace.is_active then $app_icons
                  else ($app_icons | map(gsub("foreground=\"#[^\"]+\""; "foreground=\"#7f7f7f\"")))
                  end
                ) as $icons
              | {
                  text: (
                    ($workspace.idx | tostring)
                    + if ($icons | length) > 0 then " " + ($icons | join(" ")) else "" end
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

  workspaceModules = builtins.listToAttrs (
    map (index: {
      name = "custom/niri-workspace#${index}";
      value = {
        exec = "${niriWorkspace}/bin/waybar-niri-workspace ${index}";
        return-type = "json";
        interval = 0.1;
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
        margin-top = 6;
        modules-left = [ "clock" ] ++ map (index: "custom/niri-workspace#${index}") workspaceIndexes;
        modules-center = [ "niri/window" ];
        modules-right = [
          "custom/mem"
          "custom/netbird-profile"
          "tray"
          "network"
          "backlight"
          "pulseaudio"
          "pulseaudio#source"
          "battery"
        ];

        "niri/window" = {
          format = "{}";
          icon = true;
          icon-size = 16;
          max-length = 80;
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

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "";
          on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
        };
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
        color: #ffffff;
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
        color: #ffffff;
        background-color: transparent;
        margin: 0px;
        padding: 2px 10px;
      }

      #clock {
        color: #ffffff;
        background-color: transparent;
        border-radius: 4px;
        margin-left: 0px;
      }

      #network {
        color: #ffffff;
        border-radius: 4px 0px 0px 4px;
      }

      #battery {
        color: #ffffff;
        border-radius: 0px 4px 4px 0px;
      }

      #pulseaudio {
        color: #ffffff;
      }

      #backlight {
        color: #ffffff;
      }

      #custom-niri-workspace {
        background-color: transparent;
        color: #7f7f7f;
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
        font-size: 14px;
      }

      #window {
        font-size: 14px;
        color: #ffffff;
        background-color: transparent;
        padding: 0px;
        border-radius: 0px;
      }

      #custom-niri-workspace.active,
      #custom-niri-workspace.focused {
        background-color: transparent;
        color: #ffffff;
      }

      #custom-niri-workspace.urgent {
        color: #ff6b6b;
      }

      #custom-mem {
        color: #ffffff;
        margin: 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: transparent;
        border-radius: 4px;
      }

      #custom-netbird-profile {
        color: #ffffff;
        margin: 0px;
        margin-right: 2px;
        padding: 0px 8px;
        background-color: transparent;
        border-radius: 4px;
      }

      #custom-niri-workspace:hover {
        background-color: transparent;
        color: #cfcfcf;
        box-shadow: none;
      }

      window#waybar.empty #window {
        background-color: transparent;
        padding: 0px;
      }

      #tray {
        margin: 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: transparent;
        border-radius: 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: none;
      }
    '';
  };
}
