{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ azure-cli ];
}
