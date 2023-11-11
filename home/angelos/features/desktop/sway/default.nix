#
#  Sway Home manager configuration
#

{ pkgs, config, ... }:

let 
      workspace_terminal = "1:terminal";
      workspace_www = "2:www";
      workspace_reading = "3:reading";
      workspace_coding = "4:coding";
in
{
  imports = [
    ../common
    ../common/wayland-wm
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      # Sway configuration
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.wofi}/bin/wofi --show drun";

      bars = [ ]; # No bar because using Waybar

      fonts = {
        # Font used for window tiles, navbar, ...
        names = [ "Source Code Pro" ];
        size = 10.0;
      };

      gaps = {
        # Gaps for containters
        inner = 3;
        outer = 3;
      };

      input = {
        # Input modules: $ man sway-input
        "type:touchpad" = {
          tap = "disabled";
          dwt = "enabled";
          scroll_method = "two_finger";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
        };
        "type:keyboard" = {
          xkb_layout = "us,gr";
          xkb_numlock = "enabled";
        };
      };

      output = {
        # "*".bg = "~/.config/ARTISTIC-COLORFUL-AI-LANDSCAPE-1192023.png fill";#
        "*".bg = "$HOME/.config/wallpaper.jpg fill";
        "*".scale = "1";
        # "eDP-1" = {
        #   res = "1920x1080";
        #   pos = "0 0";
        # };
        # monitor = map
        #   (m:
        #     let
        #       name = "${toString m.name}";
        #       resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        #       position = "${toString m.x}x${toString m.y}";
        #     in
        #     {
        #       "${name}" = {
        #         "mode" = "${resolution}";
        #         "pos" = "${position}";
        #       };
        #     }
        #   )
        #   (config.monitors);
      };

      defaultWorkspace = "workspace 1:terminal";
      window = {
        titlebar = false;
        border = 3;
      };

      colors.focused = {
        background = "#222222";
        border = "#dfdfdf";
        childBorder = "#dfdfdf";
        indicator = "#212121";
        text = "#ffffff";
      };

      keybindings = {
        # Hotkeys
        "${modifier}+Shift+q" = "exec swaymsg exit"; # Exit Sway
        "${modifier}+Return" = "exec ${terminal}"; # Open terminal
        "${modifier}+space" = "exec ${menu}"; # Open menu
        "${modifier}+Shift+e" = "exec ${pkgs.pcmanfm}/bin/pcmanfm"; # File Manager
        "${modifier}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy"; # Lock Screen

        "${modifier}+r" = "reload"; # Reload environment
        "${modifier}+q" = "kill"; # Kill focused window
        "${modifier}+f" = "fullscreen toggle"; # Fullscreen
        "${modifier}+h" = "floating toggle"; # Floating
        "${modifier}+Shift+h" = "focus mode_toggle"; # Floating

        "${modifier}+Left" = "focus left"; # Focus container in workspace
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";

        "${modifier}+Shift+Left" = "move left"; # Move container in workspace
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";

        #"Alt+Left" = "workspace prev";                 # Navigate to previous or next workspace if it exists
        #"Alt+Right" = "workspace next";
        "Alt+Left" = "workspace prev_on_output"; # Navigate to previous or next workspace on output if it exists
        "Alt+Right" = "workspace next_on_output";

        #"Alt+1" = "workspace number 1";                 # Open workspace x
        #"Alt+2" = "workspace number 2";
        #"Alt+3" = "workspace number 3";
        #"Alt+4" = "workspace number 4";
        #"Alt+5" = "workspace number 5";

        "Alt+Shift+Left" = "move container to workspace prev, workspace prev"; # Move container to next available workspace and focus
        "Alt+Shift+Right" = "move container to workspace next, workspace next";

        # Reload the configuration file
        "${modifier}+Shift+c" = "reload";
        #
        # Workspaces:
        #
        # Switch to workspace
        "${modifier}+1" = "workspace ${workspace_terminal}"; # 1:terminal;
        "${modifier}+2" = "workspace ${workspace_www}";
        "${modifier}+3" = "workspace ${workspace_reading}";
        "${modifier}+4" = "workspace ${workspace_coding}";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";

        # Move container to specific workspace
        "${modifier}+Shift+1" = "move container to workspace ${workspace_terminal}";
        "${modifier}+Shift+2" = "move container to workspace ${workspace_www}";
        "${modifier}+Shift+3" = "move container to workspace ${workspace_reading}";
        "${modifier}+Shift+4" = "move container to workspace ${workspace_coding}";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        "${modifier}+Control+Up" = "resize shrink height 20px"; # Resize container
        "${modifier}+Control+Down" = "resize grow height 20px";
        "${modifier}+Control+Left" = "resize shrink width 20px";
        "${modifier}+Control+Right" = "resize grow width 20px";

        # "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui"; # Screenshots

        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer -d 10"; #Volume control
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer -i 10";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t"; #Media control
        "XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source -t";
        #"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        #"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        #"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        #
        "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U  5"; # Display brightness control
        "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";


        # Switch the current container between different layout styles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
      };
    };
    extraConfig = ''
      set $opacity 0.8
      for_window [class=".*"] opacity 0.95
      for_window [app_id=".*"] opacity 0.95
      for_window [app_id="Alacritty"] opacity 1
      for_window [title="drun"] opacity $opacity
      for_window [app_id="pavucontrol"] floating enable, sticky
      for_window [app_id=".blueman-manager-wrapped"] floating enable
      for_window [title="Picture in picture"] floating enable, move position 1205 634, resize set 700 400, sticky enable
    ''; # $ swaymsg -t get_tree or get_outputs
    extraSessionCommands = ''
      #export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
    '';
  };
}
