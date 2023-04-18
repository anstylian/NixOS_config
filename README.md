# How to configure the system:

1. nix build .#nixosConfigurations.angelos.activationPackage
nixos-rebuild switch --flake .#laptop
