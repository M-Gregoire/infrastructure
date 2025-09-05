{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [
      "colored-man-pages"
      "command-not-found"
      "direnv"
      "docker"
      "docker-compose"
      "fzf"
      "git"
      # Prevent running pasted command
      "safe-paste"
      "sudo"
      "systemd"
      "tmux"
    ];

    oh-my-zsh.theme = "agnoster";
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };
}
