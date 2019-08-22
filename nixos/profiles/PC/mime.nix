{ config, pkgs, ... }:

{
  environment.variables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
  environment.etc."xdg/mimeapps.list".source = ../../../dotfiles/mimeapps.list;
}
