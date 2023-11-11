{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      pushall = "!git remote | xargs -L1 git push --all";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
    };
    userName = "Angelos Stylianidis";
    userEmail = "agathangelos.stylianidis@gmail.com";
    extraConfig = {
      feature.manyFiles = true;
      init.defaultBranch = "main";
      # user.signing.key = "TODO";
      # commit.gpgSign = true;
      # gpg.program = "${config.programs.gpg.package}/bin/gpg2";
    };
    lfs.enable = true;
    ignores = [ ".direnv" "result" "result-bin" ];
  };
}
