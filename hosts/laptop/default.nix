# Edit this configuration file to define what should be installed on
# your system.  Help is av ilable in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, user, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/display-manager
      ../../modules/desktop-environment
      ../../modules/window_manager/sway
      ../../modules/programs/swaylock
      # ../../modules/web-site
      inputs.sops-nix.nixosModules.sops
    ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      # grub = {
      #   enable = true;
      #   device = "nodev";
      #   efiSupport = true;
      #   useOSProber = true;
      #   configurationLimit = 20;
      # };
      systemd-boot = {
        # Use the systemd-boot EFI boot loader.
        enable = true;
        configurationLimit = 20;
        consoleMode = "max";
        editor = false;
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "ntfs" ];
  };

  # security.wrappers.ubridge = {
  #   source = "/run/current-system/sw/bin/ubridge";
  #   capabilities = "cap_net_admin,cap_net_raw=ep";
  #   owner = "angelos";
  #   group = "ubridge";
  #   permissions = "u+rx,g+x";
  # };
  #
  # security.wrappers.ubridge = {
  #   source = "/run/current-system/sw/bin/ubridge";
  #   capabilities = "cap_net_admin,cap_net_raw=ep";
  #   owner = "root";
  #   group = "ubridge";
  #   permissions = "u + rx,g+x";
  # };

  programs.dconf.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  services.blueman.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #  services.xserver.xkbOptions = {
  #    "eurosign:e";
  #    "caps:escape" # map caps to escape.
  #  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # Default packages installed system-wide
      ubridge
      tigervnc
    ];
  };
  security.wrappers.ubridge = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin,cap_net_raw=ep";
    source = "${pkgs.ubridge}/bin/ubridge";
  };
  services.teamviewer.enable = true;



  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  #  services.xserver.layout = "us,gr";
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us, gr";
    xkbOptions = "grp:alt_shift_toggle";
    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      # touchpad = {
      #   tapping = true;
      #   clickMethod = "clickfinger";
      # };
    };
    # synaptics = {
    #   enable = true;
    # };
    displayManager = {
      sddm = {
        enable = true;
      };
    };
  };

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/angelos/.config/sops/age/keys.txt";

  sops.secrets."myservice/my_subdir/my_secret" = {
    owner = "sometestservice";
    mode = "0440";
  };

  systemd.services."sometestservice" = {
    script = ''
      echo "
      Hey bro! I'm a service, and imma send this secure password:
      $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
      located in:
      ${config.sops.secrets."myservice/my_subdir/my_secret".path}
      to database and hack the mainframe
      " > /var/lib/sometestservice/testfile
    '';
    serviceConfig = {
      User = "sometestservice";
      WorkingDirectory = "/var/lib/sometestservice";
    };
  };

  users.users.sometestservice = {
    home = "/var/lib/sometestservice";
    createHome = true;
    isSystemUser = true;
    group = "sometestservice";
  };
  users.groups.sometestservice = { };

}
