{ config, lib, pkgs, ... }: {

  home.packages = [ pkgs.aerospace ];
  xdg.configFile."aerospace/aerospace.toml".source = ./aerospace/config.toml;
}
