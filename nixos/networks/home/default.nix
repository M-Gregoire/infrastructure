{ config, pkgs, ... }:

{
  imports = [ ../../../vendor/infrastructure-private/resources/networks/home ];

  networking.enableIPv6 = false;
}
