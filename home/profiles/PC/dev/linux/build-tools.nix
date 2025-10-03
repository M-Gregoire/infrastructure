{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ ccls gcc ];
}
