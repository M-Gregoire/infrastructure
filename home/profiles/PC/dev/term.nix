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
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory; # keep legacy behavior
    enableCompletion = true;
    initContent = ''
      # Optimize zsh-syntax-highlighting if installed
      ZSH_HIGHLIGHT_MAXLENGTH=300

      # Lazy load expensive commands with --no-rehash for faster startup
      # Note: Run 'pyenv rehash' or 'rbenv rehash' manually after installing new versions
      if command -v pyenv >/dev/null 2>&1; then
        eval "$(pyenv init - --no-rehash)"
      fi

      if command -v rbenv >/dev/null 2>&1; then
        eval "$(rbenv init - --no-rehash)"
      fi
    '';
  };

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
