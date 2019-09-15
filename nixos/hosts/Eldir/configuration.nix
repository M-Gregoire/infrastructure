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

  system.stateVersion = "16.09";

  networking.firewall.allowedTCPPorts = config.resources.firewall.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.firewall.openUDPPorts;
}
