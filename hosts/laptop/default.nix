# Edit this configuration file to define what should be installed on
# your system.  Help is av ilable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, user, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/display-manager
      ../../modules/desktop-environment
      ../../modules/hyprland
      ../../modules/window_manager/sway
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-bioot.enable = true;
  boot = { 
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 20;
        extraEntries = ''
          menuentry "Windows 10" {
            insmod part_gpt
            insmod chain
            set root='(hd0,gpt5)'
            chainloader (hd0,1)+1
          }
        '';
      };
      systemd-boot = {
        configurationLimit = 20;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
  };

  programs.dconf.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  services.blueman.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


#  services.xserver.xkbOptions = {
#    "eurosign:e";
#    "caps:escape" # map caps to escape.
#  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
#  services.xserver.layout = "us,gr";
}

