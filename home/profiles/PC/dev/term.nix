{ config, lib, pkgs, flake-root, ... }:

{
  home.packages = with pkgs;
    [
      # Terminal emulator
      kitty
    ];

  programs.bat.enable = true; # cat replacement
  programs.eza.enable = true; # ls replacement
  programs.fzf.enable = true; # fuzzy finder
  programs.zoxide.enable = true; # smart cd
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."kitty/kitty.conf".source =
    builtins.toPath "${flake-root}/dotfiles/kitty/kitty.conf";
  xdg.configFile."kitty/nord.conf".source =
    builtins.toPath "${flake-root}/dotfiles/kitty/nord.conf";
  programs.zsh = { enable = true; };

  #   oh-my-zsh.enable = true;
  #   oh-my-zsh.plugins = [
  #     "colored-man-pages"
  #     "command-not-found"
  #     "direnv"
  #     "docker"
  #     "docker-compose"
  #     "fzf"
  #     "git"
  #     # Prevent running pasted command
  #     "safe-paste"
  #     "sudo"
  #     "systemd"
  #     "tmux"
  #   ];

  #   oh-my-zsh.theme = "agnoster";
  # };
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
