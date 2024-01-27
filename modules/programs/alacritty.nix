#
# Terminal Emulator
#
# Hardcoded as terminal for rofi and doom emacs
#

{ ... }:

{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = rec {                          # Font - Laptop has size manually changed at home.nix
          normal.family = "FiraCode Nerd Font";
          bold = { style = "Bold"; };
          #size = 8;
        };
      };
    };
  };
}
