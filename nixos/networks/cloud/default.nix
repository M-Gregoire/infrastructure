{ config, pkgs, ... }:

{
  imports = [ ../../../vendor/infrastructure-private/resources/networks/cloud ];

  networking.nameservers = config.resources.networking.DNS;
}
