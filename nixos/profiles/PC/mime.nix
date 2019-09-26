{ config, pkgs, ... }:

{
  environment.variables.XDG_CONFIG_DIRS = [ "/etc/xdg" ];
  environment.etc."xdg/mimeapps.list".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/mimeapps.list";
}
