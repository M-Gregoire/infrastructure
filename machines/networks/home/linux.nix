{ config, lib, pkgs, ... }:

{
  networking.nameservers = config.resources.networking.DNS;
  networking.enableIPv6 = false;
}
