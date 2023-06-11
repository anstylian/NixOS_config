# How to configure the system:

1. nix build .#nixosConfigurations.angelos.activationPackage
nixos-rebuild switch --flake .#laptop

2. text with local VM
nixos-rebuild build-vm --flake .#laptop
./result/bin/run-*-vm

3. To update a flake
`nix flake update`
