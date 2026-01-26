{ config, network, ... }:

{
  programs.git = {
    enable = true;
    userEmail =
      if network != "work" then config.resources.services.git.email else null;
    userName = "${config.resources.services.git.username}";
    # TODO: Depends if work laptop or not
    signing = {
      signByDefault = true;
      # key = config.resources.gpg.publicKey.fingerprint;
    };
    includes = if network == "work" then [{
      path = "~/.config/gitsign/gitconfig";
    }] else
      [ ];
    aliases = {
      st = "status";
      ci = "commit";
      br = "branch";
      co = "checkout";
      df = "diff";
      dc = "diff --cached";
      lg = "log -p";
      pr = "pull --rebase";
      p = "push";
      ppr = "push --set-upstream origin";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      latest =
        "for-each-ref --sort=-taggerdate --format='%(refname:short)' --count=1";
      undo = "git reset --soft HEAD^";
      brd = "branch -D";
    };
    ignores = [ "*.log" ".envrc" "shell.nix" ];
    extraConfig = {
      core = { editor = "emacsclient"; };
      "difftool \"ediff\"" = {
        cmd = ''
          emacsclient --eval \"(ediff-files \\\"$LOCAL\\\" \\\"$REMOTE\\\")\"'';
      };
      diff = { tool = "ediff"; };
      color = { ui = true; };
      branch = { autosetupmerge = "always"; };
      # https://stackoverflow.com/a/21866819/4187028
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      credential = { helper = "cache --timeout=3600"; };
    };
  };
}
