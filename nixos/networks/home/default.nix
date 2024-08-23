{ config, pkgs, private-config, ... }:

{
  imports = [
    "${private-config}/resources/networks/home"
    (if pkgs.stdenv.isLinux then (import ./linux.nix) else { })
  ];

}
