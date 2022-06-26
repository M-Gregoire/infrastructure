{ config, pkgs, ... }:

{
  xdg.configFile."wpg/templates/dunstrc.base".source = pkgs.substituteAll {
    src = /. + "${config.resources.paths.publicDotfiles}" + /dunst/dunstrc.base;
    user = "${config.resources.username}";
  };
}
