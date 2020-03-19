{ config, pkgs, ... }:

{
  imports = [
    ../../../vendor/infrastructure-private/resources/networks/home/default.nix
  ];

}
