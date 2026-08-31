{ config, pkgs, ... }:

{
  networking.nameservers = config.resources.networking.DNS;
}
