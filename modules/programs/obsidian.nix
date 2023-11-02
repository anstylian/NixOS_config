#
# System Menu
#

{ config, lib, pkgs, ... }:

{ 
    environment.systemPackages = with pkgs; [
      obsidian
    ];
}
