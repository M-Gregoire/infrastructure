{ config, pkgs, ... }:

{
  imports =
    [
      ../../dev/docker.nix
      ../../common.nix
      ./hardware-configuration.nix
      ../../profiles/Server
      ../../../resources/hosts/Rind
      ../../../vendor/infrastructure-private/resources/hosts/Rind
      ./nixos-in-place.nix
      ../../networks/cloud
    ];

  system.stateVersion = "16.09";
}
