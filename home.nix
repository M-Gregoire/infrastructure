{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
  hone.username = "${config.resources.username}";
  home.homeDirectory = (if pkgs.stdenv.isLinux then
    "/home/${config.resources.username}"
  else
    "/Users/${config.resources.username}");
}
