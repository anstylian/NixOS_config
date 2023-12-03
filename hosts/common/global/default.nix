# This file (and the global directory) holds config that i use on all hosts
{ pkgs, inputs, outputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./docker.nix
    ./fish.nix
    ./locale.nix
    ./nix.nix
    # ./openssh.nix TODO
    # ./optin-persistence.nix
    ./sops.nix
    # ./systemd-initrd.nix
    # ./ssh-serve-store.nix
    # ./steam-hardware.nix
  ];

  environment = {
    systemPackages = with pkgs; [           # Default packages installed system-wide
      vim
      killall
      pciutils
      usbutils
      wget
      tree
      binutils
      file
    ];
  };

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment.enableAllTerminfo = true;
}
