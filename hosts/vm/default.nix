#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./vm
#   │       ├─ default.nix *
#   │       └─ hardware-configuration.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ bspwm.nix
#

{ config, pkgs, ... }:

{
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
          canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_6_1;
  };

#  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.firewall.enable = true;
#  boot.loader.grub.device = "/dev/sda";
}
