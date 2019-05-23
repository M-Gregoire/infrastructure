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
    ];

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
  };

  system.stateVersion = "16.09";
}
