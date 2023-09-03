#
#  Shell
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./shell
#           └─ default.nix *
#               └─ ...
#

[
  ./zsh.nix
  ./direnv.nix
  ./tmux/tmux.nix
]



