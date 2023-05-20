#
#  Home-manager configuration for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │       └─ home.nix *
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#              └─ home.nix
#

{ ... }:

{
  imports =
    [
      ../../modules/programs/neovim
    ];

}
