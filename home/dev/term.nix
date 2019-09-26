{ pkgs, config, lib, ... }:

{
  imports = [
    ../../vendor/infrastructure-private/resources/home/aliases.nix
  ];

  home.packages = with pkgs; [
    kitty
    bat
  ];

  xdg.configFile."kitty/kitty.conf".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/kitty/kitty.conf";

  programs = {
    zsh = {
      enable = true;
      plugins = [
        {
          name = "base16-shell";
          src =  ./../../vendor/base16-shell;
        }
      ];
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [
        "sudo"
        "git"
      ];
      oh-my-zsh.theme = "agnoster";
      enableCompletion = true;

      initExtra = ''
        khal && ${config.resources.pcs.paths.scripts}/showTodo.sh
        # https://github.com/gopasspw/gopass/issues/585#issuecomment-355339632
        source <(gopass completion zsh | head -n -1 | tail -n +2)
        compdef _gopass gopass
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
