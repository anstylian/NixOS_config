{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./github-cli.nix
    ./git.nix
    # ./gpg.nix
    # ./nix-index.nix
    ./pfetch.nix
    # ./shellcolor.nix
    ./ssh.nix
    ./starship.nix
    ./neovim
  ];

  home.packages = with pkgs; [
    comma             # Install and run programs by sticking a , before them
    distrobox         # Nice escape hatch, integrates docker images with my environment

    bc                # Calculator
    bottom            # System viewer
    ncdu              # TUI disk usage
    jq                # JSON pretty printer and manipulator
    btop              # Resource Manager
    nitch             # Minimal fetch
    ranger            # File Manager
    tldr              # Helper
    ranger            # File browser 
    unzip             # Zip files
    zip               # Zip files
    lm_sensors        # Computer temperature sensors
    ntfs3g            # mount ntfs filesystem

    eza               # Better ls
    ripgrep           # Better grep
    fd                # Better find
    httpie            # Better curl
    diffsitter        # Better diff
    bat               # Better top
    tre-command       # Better tree
    dutree            # Better du
    tldr              # Better man

    nil               # Nix LSP
    nixfmt            # Nix formatter

    ltex-ls           # Spell checking LSP

    vim
    neovim
  ];
}
