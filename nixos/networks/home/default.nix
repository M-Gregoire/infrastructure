{ config, pkgs, ... }:

{
  imports = [
    ../../../vendor/infrastructure-private/resources/networks/home/default.nix
  ];

  networking.hosts = {
    "${config.resources.hosts.beyla.ip.default}" = [ "Beyla" ];
    "${config.resources.hosts.octopi.ip.default}" = [ "Octopi" ];
  };
}
