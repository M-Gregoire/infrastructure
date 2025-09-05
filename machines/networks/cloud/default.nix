{ config, pkgs, private-config, ... }:

{
  imports = [ "${private-config}/resources/networks/cloud" ];

  networking.nameservers = config.resources.networking.DNS;
}
