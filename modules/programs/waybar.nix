#
# Bar
#

{ config, lib, pkgs, host, user, ...}:

{
  environment.systemPackages = with pkgs; [
    waybar
    networkmanagerapplet
  ];

  nixpkgs.overlays = [                                      # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work (for now done with hyprland.nix)
     (self: super: {
       waybar = super.waybar.overrideAttrs (oldAttrs: {
         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
         patchPhase = ''
           substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
         '';
       });
     })
   ];
  home-manager.users.${user} = {                           # Home-manager waybar config
    programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";                     # Needed for waybar to start automatically
      };

      style = ''
        * {
            border: none;
            border-radius: 0;
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: Liberation Mono;
            min-height: 0px;
        }

        window#waybar {
            background: transparent;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
            margin-right: 8px;
            margin-left: 8px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            background: #383c4a;
        }

        #workspaces button {
            transition: none;
            color: #7c818c;
            background: transparent;
            padding: 5px;
            font-size: 18px;
        }

        #workspaces button.persistent {
            color: #7c818c;
            font-size: 12px;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            transition: none;
            box-shadow: inherit;
            text-shadow: inherit;
            border-radius: inherit;
            color: #383c4a;
            background: #7c818c;
        }

        #workspaces button.focused {
            color: white;
        }

        #custom-menu {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            color: #A7C7E7;
            background: #383c4a;
        }

        #language {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #keyboard-state {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #custom-mail {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #mode {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #clock {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 0px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #custom-weather {
            padding-right: 16px;
            border-radius: 0px 0px 10px 0px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #pulseaudio {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #pulseaudio.muted {
            background-color: #90b1b1;
            color: #2a5c45;
        }

        #custom-mem {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #cpu {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #temperature {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #temperature.critical {
            background-color: #eb4d4b;
        }

        #backlight {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #network {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #battery {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        #battery.charging {
            color: #ffffff;
            background-color: #26A65B;
        }

        #battery.warning:not(.charging) {
            background-color: #ffbe61;
            color: black;
        }

        #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: #ffffff;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #tray {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 0px 0px 10px 10px;
            transition: none;
            color: #ffffff;
            background: #383c4a;
        }

        @keyframes blink {
            to {
                background-color: #ffffff;
                color: #000000;
            }
        }
      '';
      settings = with host; {
        Main = {
          # "layer" = "top"; # Waybar at top layer
          "position" = "top"; # Waybar position (top|bottom|left|right)
          # "height": 30, // Waybar height (to be removed for auto height)
          "margin" = "5 20 0 20";
          # "width": 1280, // Waybar width
          # Choose the order of the modules
          modules-left = [ "custom/menu" "sway/language" "sway/workspaces" "sway/mode"];
          modules-center = ["clock" "custom/weather"];
          modules-right = ["pulseaudio" "custom/mem" "cpu" "temperature" "backlight" "battery" "network" "tray"];


          # ***************************
          # *  mODULES CONFIGURATION  *
          # ***************************

          "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
          };

          "sway/language" = {
            "format" = "{} ";
	          "min-length" = 5;
	          "tooltip" = false;
          };

          "keyboard-state" = {
              "numlock" = true;
              "capslock" = true;
              "format" = {
                  "numlock" = " 𐄡 {icon}";
                  "capslock" = "A {icon}";
              };
              "format-icons" = {
                  "locked" = "🔒";
                  "unlocked" = " ";
              };
          };

          "sway/mode" = {
              "format" = "<span style=\"italic\">{}</span>";
          };

          "clock" = {
              "timezone" = "Europe/Athens";
              "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              "format" = "{:%a, %d %b, %I:%M %p} 🕑";
          };

          "custom/weather" = {
              "format" = "{}";
              "tooltip" = true;
              "interval" = 1800;
              "exec" = "$HOME/.config/waybar/script/cy-live-weather --station LEFKOSIA";
              "return-type" = "json";
          };

          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            format-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            #format-source = "{volume}% <span font='11'></span>";
            format-source = "<span font='10'></span> ";
            format-source-muted = "<span font='11'> </span> ";
            format-icons = {
              default = [ "" "" "" ];
              headphone = "";
              #hands-free = "";
              #headset = "";
              #phone = "";
              #portable = "";
              #car = "";
            };
            tooltip-format = "{desc}, {volume}%";
            on-click = "${pkgs.pamixer}/bin/pamixer -t";
            on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
            on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          "custom/mem" = {
              "format" = "{} ";
              "interval" = 3;
              "exec" = "free -h | awk '/Mem:/{printf $3}'";
              "tooltip" = false;
          };

          "temperature" = {
              # "thermal-zone": 2,
              # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
              "critical-threshold" = 80;
              # "format-critical": "{temperatureC}°C {icon}",
              "format" = "{temperatureC}°C {icon}";
              "format-icons" = ["" "" "" "" ""];
              "tooltip" = false;
          };

          backlight = {
            device = "intel_backlight";
            format= "{percent}% <span font='11'>{icon}</span>";
            format-icons = ["" ""];
            on-scroll-down = "${pkgs.light}/bin/light -U 5";
            on-scroll-up = "${pkgs.light}/bin/light -A 5";
          };

          battery = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% <span font='11'>{icon}</span>";
            format-charging = "{capacity}% <span font='11'></span>";
            format-icons = ["" "" "" "" ""];
            max-length = 25;
          };

          "tray" = {
              "icon-size" = 16;
              "spacing" = 0;
          };

          "cpu" = {
              "interval" = 10;
              "format" = "{}% <span font='11'></span>";
              "max-length" = 10;
          };

          network = {
            format-wifi = "<span font='11'></span>";
            format-ethernet = "<span font='11'></span>";
            #format-ethernet = "<span font='11'></span> {ifname}: {ipaddr}/{cidr}";
            format-linked = "<span font='11'>睊</span> {ifname} (No IP)";
            format-disconnected = "<span font='11'>睊</span> Not connected";
            #format-alt = "{ifname}: {ipaddr}/{cidr}";
            tooltip-format = "{essid} {ipaddr}/{cidr}";
            #on-click-right = "${pkgs.alacritty}/bin/alacritty -e nmtui";
          };

          "custom/menu" = {
            format = "<span font='16'> </span>";
            #on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu -theme $HOME/.config/rofi/config.rasi";
            #on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
            on-click = ''~/.config/wofi/power.sh'';
            on-click-right = "${pkgs.wofi}/bin/wofi --show drun";
            tooltip = false;
          };
        };
        Sec = if hostName == "desktop" || hostName == "work" then {
          layer = "top";
          position = "top";
          height = 16;
          output = [
            "${secondMonitor}"
          ];
          modules-left = [ "custom/menu" "wlr/workspaces" ];

          modules-right =
            if hostName == "desktop" then
              [ "custom/ds4" "custom/pad" "pulseaudio" "custom/sink" "custom/pad" "clock"]
            else
              [ "cpu" "memory" "custom/pad" "battery" "custom/pad" "backlight" "custom/pad" "pulseaudio" "custom/pad" "clock" ];

          "custom/pad" = {
            format = "      ";
            tooltip = false;
          };

          "custom/menu" = {
            format = "<span font='16'></span>";
            #on-click = "${pkgs.rofi}/bin/rofi -show p -modi p:${pkgs.rofi-power-menu}/bin/rofi-power-menu -theme $HOME/.config/rofi/config.rasi";
            #on-click-right = "${pkgs.rofi}/bin/rofi -show drun";
            on-click = ''~/.config/wofi/power.sh'';
            on-click-right = "${pkgs.wofi}/bin/wofi --show drun";
            tooltip = false;
          };
          "wlr/workspaces" = {
            format = "<span font='11'>{name}</span>";
            #format = "<span font='12'>{icon}</span>";
            #format-icons = {
            #  "1"="";
            #  "2"="";
            #  "3"="";
            #  "4"="";
            #  "5"="";
            #  "6"="";
            #  "7"="";
            #  "8"="";
            #  "9"="";
            #  "10"="";
            #};
            active-only = true;
            on-click = "activate";
            #on-scroll-up = "hyprctl dispatch workspace e+1";
            #on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          clock = {
            format = "{:%b %d %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            #format-alt = "{:%A, %B %d, %Y} ";
          };
          cpu = {
            format = " {usage}% <span font='11'></span> ";
            interval = 1;
          };
          disk = {
            format = "{percentage_used}% <span font='11'></span>";
            path = "/";
            interval = 30;
          };
          memory = {
            format = "{}% <span font='11'></span>";
            interval = 1;
          };
          backlight = {
            device = "intel_backlight";
            format= "{percent}% <span font='11'>{icon}</span>";
            format-icons = ["" ""];
            on-scroll-down = "${pkgs.light}/bin/light -U 5";
            on-scroll-up = "${pkgs.light}/bin/light -A 5";
          };
          battery = {
            interval = 60;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% <span font='11'>{icon}</span>";
            format-charging = "{capacity}% <span font='11'></span>";
            format-icons = ["" "" "" "" ""];
            max-length = 25;
          };
          pulseaudio = {
            format = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source} ";
            format-bluetooth-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            format-muted = "<span font='11'>x</span> {volume}% {format_source} ";
            #format-source = "{volume}% <span font='11'></span> ";
            format-source = "<span font='10'></span> ";
            format-source-muted = "<span font='11'></span> ";
            format-icons = {
              default = [ "" "" "" ];
              headphone = "";
              #hands-free = "";
              #headset = "";
              #phone = "";
              #portable = "";
              #car = "";
            };
            tooltip-format = "{desc}, {volume}%";
            on-click = "${pkgs.pamixer}/bin/pamixer -t";
            on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
            on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
          };
          "custom/sink" = {
            #format = "<span font='10'>蓼</span>";
            format = "{}";
            exec = "$HOME/.config/waybar/script/sink.sh";
            interval = 2;
            on-click = "$HOME/.config/waybar/script/switch.sh";
            tooltip = false;
          };
        } else {};
      };
    };
    home.file = {
      ".config/waybar/script/sink.sh" = {              # Custom script: Toggle speaker/headset
        text = ''
          #!/bin/sh

          HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
          SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

          if [[ $HEAD = "*" ]]; then
            printf "<span font='13'></span>\n"
          elif [[ $SPEAK = "*" ]]; then
            printf "<span font='10'>蓼</span>\n"
          fi
          exit 0
        '';
        executable = true;
      };
      ".config/waybar/script/switch.sh" = {              # Custom script: Toggle speaker/headset
        text = ''
          #!/bin/sh

          ID1=$(awk '/ Built-in Audio Analog Stereo/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | head -n 1)
          ID2=$(awk '/ S10 Bluetooth Speaker/ {sub(/.$/,"",$2); print $2 }' <(${pkgs.wireplumber}/bin/wpctl status) | sed -n 2p)

          HEAD=$(awk '/ Built-in Audio Analog Stereo/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | sed -n 2p)
          SPEAK=$(awk '/ S10 Bluetooth Speaker/ { print $2 }' <(${pkgs.wireplumber}/bin/wpctl status | grep "*") | head -n 1)

          if [[ $HEAD = "*" ]]; then
            ${pkgs.wireplumber}/bin/wpctl set-default $ID2
          elif [[ $SPEAK = "*" ]]; then
            ${pkgs.wireplumber}/bin/wpctl set-default $ID1
          fi
          exit 0
        '';
        executable = true;
      };
    };
  };
}
