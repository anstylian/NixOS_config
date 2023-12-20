#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#              └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      #       ../../modules/hyprland/home.nix             # Window Manager
      ../../modules/window_manager/sway/home.nix # Window Manager
      ../../modules/programs/neovim
      ../../modules/programs/swaylock/home.nix # Screen lock
      ../../modules/programs/mako.nix
      ../../modules/shell/tmux/home.nix
    ];


  home = {
    # Specific packages for laptop
    packages = with pkgs; [
      mpvpaper
      mpv
      # Applications
      libreoffice # Office packages

      # Display
      #light                              # xorg.xbacklight not supported. Other option is just use xrandr.

      # Power Management
      #auto-cpufreq                       # Power management
      #tlp                                # Power management

      alsa-utils # Audio control

      # dunst            # Notifications

      dutree

      zathura
      # obsidian

      signal-desktop

      gns3-gui
      gns3-server
      qemu
      kvmtool
      libvirt
      inetutils

      teamviewer
    ];
  };

  programs = {
    alacritty.settings.font.size = 11;
    gpg.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };
    # Applets
    blueman-applet.enable = true; # Bluetooth
    network-manager-applet.enable = true; # Network
    #   cbatticon = {
    #     enable = true;
    #     criticalLevelPercent = 10;
    #     lowLevelPercent = 20;
    #     iconType = null;
    #   };
  };

}
