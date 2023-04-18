#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./laptop
#            ├─ ./default.nix
#            └─ ./home.nix 
#

{ lib, inputs, nixpkgs, home-manager, user, location, hyprland, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  laptop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit inputs user location;
      host = {
        hostName = "laptop";
        mainMonitor = "eDP-1";
      };
    };
    modules = [
      hyprland.nixosModules.default
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "laptop";
            mainMonitor = "eDP-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./laptop/home.nix)];
        };
      }
    ];
  };

}
