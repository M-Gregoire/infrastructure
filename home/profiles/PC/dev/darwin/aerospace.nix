{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [ pkgs.aerospace ];

  home.file.".aerospace.toml".source = ./aerospace/config.toml;
}
