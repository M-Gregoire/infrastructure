{ config, pkgs, flake-root, ... }:

{
  xdg.configFile."wpg/templates/dunstrc.base".source = pkgs.substituteAll {
    src = "${flake-root}/dotfiles/dunst/dunstrc.base";
    user = "${config.resources.username}";
  };
}
