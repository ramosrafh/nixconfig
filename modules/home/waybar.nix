{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 8;
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
          format = "  {}";
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
          format-charging = "󰂄  {capacity}%";
          format-plugged = "󰂄  {capacity}%";
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
          format-ethernet = "  {essid}";
          format-linked = "{ifname} (No IP)  ";
          format-disconnected = "󰤭  Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "󰖁";
          scroll-step = 1;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "󰖀" "" ];
          };
        };

        "pulseaudio#source" = {
          format = "{format_source}";
          format-source = "  {volume}%";
          format-source-muted = "";
          on-click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          on-scroll-up = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
        };
      };
    };
    
    style = ''
      * {
        font-family: monospace;
        font-weight: bold;
        font-size: 14.5px;
        border-radius: 0px;
      }

      window#waybar {
        background-color: transparent;
        color: #bac2df;
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
        color: #74c7ec;
        background-color: #181825;
        margin: 3px 0px;
        padding: 2px 10px;
      }

      #clock {
        color: #bac2df;
        background-color: #181825;
        border-radius: 4px;
        margin-left: 0px;
      }

      #network {
        color: #cba6f7;
        border-radius: 4px 0px 0px 4px;
      }

      #battery {
        color: #74c7ec;
        border-radius: 0px 4px 4px 0px;
      }

      #pulseaudio {
        color: #f9e2af;
      }

      #backlight {
        color: #f38ba8;
      }

      #workspaces {
        background-color: #181825;
        color: #bac2df;
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
        background-color: rgba(157, 170, 204, 1);
        color: rgba(0, 0, 0, 1);
        padding: 0px 3px 0px 3px;
        border-radius: 4px;
      }

      #workspaces button {
        color: #bac2df;
        padding: 0 3px 0 3px;
        border-radius: 4px;
      }

      #custom-mem {
        color: #bac2df;
        margin: 3px 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: #181825;
        border-radius: 4px;
      }

      #workspaces button:hover {
        background-color: #bac2df;
        color: #181825;
        background: #bac2df;
        box-shadow: none;
      }

      #tray {
        margin: 3px 0px;
        margin-right: 10px;
        padding: 0px 10px;
        background-color: #181825;
        border-radius: 4px;
      }
    '';
  };
}
