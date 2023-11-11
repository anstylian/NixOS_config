{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs = # All flake references used to build my NixOS setup. These are dependencies.
    {
      # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                  # Nix Packages
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages

      # Latest stable branch of nixpkgs, used for version rollback
      # The current latest version is 23.05
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      nix-colors.url = "github:misterio77/nix-colors";
      sops-nix.url = "github:mic92/sops-nix";

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      astro-nvim = {
        url = "github:AstroNvim/AstroNvim";
        flake = false;
      };
      # nvim-config = {
      #   url = "github:Mic92/dotfiles";
      # };

      # petclinic = {
      #   # url = "path:/home/angelos/Documents/git/douglas-adams-quotes";
      #   url = "path:/home/angelos/Documents/git/petclinic";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

      # firefox-addons = {
      #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

    };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" ];

      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      inherit lib;

      homeManagerModules = import ./modules/home-manager;

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        laptop = lib.nixosSystem {
          modules = [ ./hosts/laptop ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "angelos@laptop" = lib.homeManagerConfiguration {
          modules = [ ./home/angelos/laptop.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        # Portable minimum configuration
        "angelos@generic" = lib.homeManagerConfiguration {
          modules = [ ./home/angelos/generic.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };
    };
}
