{ pkgs, ...}:

{
  imports = [ ../programs/waybar.nix ];

  programs.hyprland.enable = true;
}
