{ pkgs, ... }:
let
  brokenPine = import ./broken-pine.nix;
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 6;
        modules-left = [ "clock" "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [ "tray" "custom/mem" "network" "backlight" "pulseaudio" "pulseaudio#source" "battery" ];

        "niri/window" = {
          format = "{}";
          max-length = 80;
        };

        "niri/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          on-click = "activate";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
            sort-by-number = true;
          };
        };

        tray = {
          icon-size = 13;
          spacing = 10;
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon}  {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
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
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
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
            default = [ " " " " " " ];
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
      #tray,
      #workspaces,
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

      #workspaces {
        background-color: transparent;
        color: #7f7f7f;
        margin-left: 10px;
        margin-right: 0px;
        padding: 0 3px 0 3px;
        border-radius: 4px;
        box-shadow: none;
      }

      #workspaces label {
        font-size: 14px;
      }

      #workspaces button.active {
        background-color: transparent;
        color: #ffffff;
        padding: 0px;
        margin: 0px;
        border-radius: 4px;
        min-width: 28px;
        min-height: 28px;
      }

      #workspaces button {
        all: unset;
        color: #7f7f7f;
        padding: 0px;
        margin: 0px;
        border-radius: 4px;
        min-width: 28px;
        min-height: 28px;
      }

      #custom-mem {
        color: #ffffff;
        margin: 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: transparent;
        border-radius: 4px;
      }

      #workspaces button:hover {
        background-color: transparent;
        color: #cfcfcf;
        background: transparent;
        box-shadow: none;
      }

      #tray {
        margin: 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: transparent;
        border-radius: 4px;
      }
    '';
  };
}
