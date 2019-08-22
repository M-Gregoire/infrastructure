{ config, pkgs, ... }:

{
  networking.hosts = {
    "${config.resources.hosts.beyla.ip}" = [ "Beyla" "${config.resources.aliases.router}" ];
    "${config.resources.hosts.octopi.ip}" = [ "Octopi" "${config.resources.aliases.octopi}" ];
  };
}
