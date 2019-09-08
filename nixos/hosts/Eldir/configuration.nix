{ config, pkgs, ... }:

{
  imports =
    [
      ../../common.nix
      ./hardware-configuration.nix
      ../../profiles/Server
      ../../../resources/hosts/Eldir
      ../../networks/cloud
      ../../../vendor/infrastructure-private/resources/hosts/Eldir
      ./nixos-in-place.nix
    ];

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
  };

  system.stateVersion = "16.09";

  networking.firewall.allowedTCPPorts = config.resources.hosts.eldir.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.hosts.eldir.openUDPPorts;
}
