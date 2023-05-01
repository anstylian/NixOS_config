#
# tmux
#

{
  programs = {
    tmux = {
      enable = true;
      historyLimit = 1000000;
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
