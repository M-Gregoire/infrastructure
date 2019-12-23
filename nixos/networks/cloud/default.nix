{ config, pkgs, ... }:

{
  imports = [
    ../../../vendor/infrastructure-private/resources/networks/cloud/default.nix
  ];

  networking.nameservers = config.resources.networking.DNS;
}
