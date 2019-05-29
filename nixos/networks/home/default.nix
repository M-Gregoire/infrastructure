{ config, pkgs, ... }:

{
  networking.hosts = {
    "${config.resources.hosts.beyla}" = [ "Beyla" ];
    "${config.resources.hosts.octopi}" = [ "Octopi" ];
  };
}
