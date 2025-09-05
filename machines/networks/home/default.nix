{ config, pkgs, private-config, ... }:

{
  networking.nameservers = config.resources.networking.DNS;
}
