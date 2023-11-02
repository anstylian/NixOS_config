#
#  G'Day
#  Behold is my personal Nix, NixOS and Darwin Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README and other org document on how to use these files.
#  Currently and possibly forever a Work In Progress.
#
#  flake.nix
#

{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

      # Latest stable branch of nixpkgs, used for version rollback
      # The current latest version is 23.05
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nixos-hardware = {
        url = "github:NixOS/nixos-hardware/master";
      };

      astro-nvim = {
        url = "github:AstroNvim/AstroNvim";
        flake = false;
      };

      petclinic = {
        # url = "path:/home/angelos/Documents/git/douglas-adams-quotes";
        url = "path:/home/angelos/Documents/git/petclinic";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, home-manager, nixos-hardware, astro-nvim, petclinic, ... }: # Function that tells my flake which to use and what do what to do with the dependencies.
    let # Variables that can be used in the config files.
      user = "angelos";
      location = "$HOME/.setup";
    in
    # Use above variables in ...
    {
      nixosConfigurations = (
        # NixOS configurations
        import ./hosts {
          # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user location nixos-hardware astro-nvim petclinic; # Also inherit home-manager so it does not need to be defined here.
        }
      );
    };
}
