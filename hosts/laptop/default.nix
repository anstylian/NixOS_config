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
      telegraf
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

  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          # Listening Address
          http_addr = "127.0.0.1";
          # and Port
          http_port = 3000;
          # Grafana needs to know on which domain and URL it's running
          # domain = "your.domain";
          # root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
          serve_from_sub_path = true;
        };
      };
    };
    influxdb2 = {
      enable = true;
      # api key: zZuMHEZn34CNtkeFzJ1ptMoDUFShuwzonS5Yb-ppc7g1FhRkspIxveBuJlB42zzrQfLKAIEy5IATHoXRCJ8Q5A==
    };
    prometheus = {
      enable = true;
      port = 9090;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9000;
        };
      };
      scrapeConfigs = [
        {
          job_name = "chrysalis";
          static_configs = [{
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];
    };
    # telegraf = {
    #   enable = true;
    #   extraConfig = {
    #     outputs.influxdb_v2 = {
    #       urls = [ "http://127.0.0.1:8086" ];
    #       token = "zZuMHEZn34CNtkeFzJ1ptMoDUFShuwzonS5Yb-ppc7g1FhRkspIxveBuJlB42zzrQfLKAIEy5IATHoXRCJ8Q5A==";
    #       bucket = "telegraf";
    #       organization = "0858801ad6ccbb13";
    #       # database = "telegraf";
    #     };
    #     inputs.cpu = {
    #       percpu = true;
    #       totalcpu = true;
    #       taginclude = [ "cpu" ];
    #     };
    #     # inputs.mqtt_consumer = {
    #     #   servers = ["tcp://127.0.0.1:1883"];
    #     #   topics = [
    #     #     "telegraf/test/topic/qwe"
    #     #     "telegraf/test/topic/asd"
    #     #     "hello/world"
    #     #     "hello/+/world"
    #     #   ];
    #     # };
    #     # inputs.statsd = {
    #     #   service_address = ":8125";
    #     #   delete_timings = true;
    #     # };
    #   };
    # };
  };
}
