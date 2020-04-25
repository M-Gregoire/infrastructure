{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Terminfo for Kitty
    kitty.terminfo
    # make
    gnumake
    # git
    git
    # Utilities
    wget unzip
    # Certificate
    openssl
  ];

  programs = {
    # Needed for LightDM to remember the user
    # See https://github.com/NixOS/nixpkgs/issues/10349#issuecomment-341810990
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
      ohMyZsh.plugins = [
        "sudo"
        "git"
      ];
      ohMyZsh.theme = "agnoster";
      enableCompletion = true;
      # Fix Tramp (Emacs) with ZSH https://www.emacswiki.org/emacs/TrampMode#toc9
      loginShellInit = "[[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return";
    };
  };
}
