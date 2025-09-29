{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [ age sops ];

  imports = let
    folder = ./dev;
    files = builtins.attrNames (builtins.readDir folder);
    nixFiles =
      builtins.filter (name: builtins.match ".*\\.nix" name != null) files;
  in map (name: folder + "/${name}") nixFiles;

  home.activation = {
    folders = ''
      mkdir -p ${config.resources.paths.home}/src/
      mkdir -p ${config.resources.paths.home}/Screenshots/
    '';
  };
}
