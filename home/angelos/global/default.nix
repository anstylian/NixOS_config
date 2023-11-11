{ inputs, lib, pkgs, config, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModule
    ../features/cli
    ../features/helix
    # ../features/neovim
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  nixpkgs = {
    # overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "angelos";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
    };

    # persistence = {
    #   "/persist/home/angelos" = {
    #     directories = [
    #       "Documents"
    #       "Downloads"
    #       "Pictures"
    #       "Videos"
    #       ".local/bin"
    #     ];
    #     allowOther = true;
    #   };
    # };
    file.".config/wallpaper.jpg".source = config.wallpaper;
  };

  # colorscheme = lib.mkDefault colorSchemes.dracula;
  colorscheme = lib.mkDefault colorSchemes.monokai;
  # wallpaper =
  #   let
  #     largest = f: xs: builtins.head (builtins.sort (a: b: a > b) (map f xs));
  #     largestWidth = largest (x: x.width) config.monitors;
  #     largestHeight = largest (x: x.height) config.monitors;
  #   in
  #   lib.mkDefault (nixWallpaperFromScheme
  #     {
  #       scheme = config.colorscheme;
  #       width = largestWidth;
  #       height = largestHeight;
  #       logoScale = 4;
  #     });
  home.file.".colorscheme".text = config.colorscheme.slug;
}
