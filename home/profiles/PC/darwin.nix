{ config, lib, pkgs, ... }:

{
  imports = let
    folder = ./dev/darwin;
    files = builtins.attrNames (builtins.readDir folder);
    nixFiles =
      builtins.filter (name: builtins.match ".*\\.nix" name != null) files;
  in map (name: folder + "/${name}") nixFiles;

  home.file.".hammerspoon".source = ./dev/darwin/hammerspoon;
  home.file.".hammerspoon".recursive = true;

}
