{ config, pkgs, private-config, ... }:

{
  imports = [ "${private-config}/resources/networks/home" ];

  networking.enableIPv6 = false;
}
