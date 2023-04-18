# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, user, inputs,  ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-bioot.enable = true;
  boot = { 
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI";
      };
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 100;
      };
      timeout = 5;
    };
    kernelParams = [
      "i915.enable_dpcd_backlight=1"
      # fix flicker
      # source https://wiki.archlinux.org/index.php/Intel_graphics#Screen_flickering
      "i915.enable_psr=0"
    ];
  };

  programs.dconf.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };


  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      setupCommands = ''
#      UP='DP-1'
#      CENTER='eDP-1'
#      ${pkgs.xorg.xrandr}/bin/xrandr --output $CENTER --rotate normal --output $UP --rotate normal --above $CENTER 
'';
    };
  
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };

  

  # Configure keymap in X11
  services.xserver.layout = "us";
#  services.xserver.xkbOptions = {
#    "eurosign:e";
#    "caps:escape" # map caps to escape.
#  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      llt = "ls -l -t";
    };
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "man" ];
      theme = "robbyrussell";
    };
  };

}

