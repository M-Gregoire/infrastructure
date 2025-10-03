{ config, pkgs, lib, ... }:

{
  home.shellAliases = {
    cd = "z";
    cat = "bat";
    ls = "eza";
  };
}
