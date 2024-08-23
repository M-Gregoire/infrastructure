{ config, lib, pkgs, ... }:

{
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
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
    theme = "agnoster";
  };
}
