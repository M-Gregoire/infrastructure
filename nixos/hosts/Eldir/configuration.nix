{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/Eldir
      ../../../vendor/infrastructure-private/resources/hosts/Eldir
      ../../common.nix
      ../../networks/cloud
      ../../profiles/Server
      ./hardware-configuration.nix
      ./nixos-in-place.nix
    ];

  system.stateVersion = "19.03";

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.eldir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.eldir.ssh.port ];
}
