{ config, pkgs, ... }:

{
  imports = [
    ../../../vendor/infrastructure-private/resources/networks/home/default.nix
  ];

  networking.hosts = {
    "${config.resources.hosts.beyla.ip}" = [ "Beyla" ];
    "${config.resources.hosts.octopi.ip}" = [ "Octopi" ];
  };
}
