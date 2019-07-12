{ config, pkgs, ... }:

{
  networking.hosts = {
    "${config.resources.hosts.beyla}" = [ "Beyla" "${config.resources.aliases.router}" ];
    "${config.resources.hosts.octopi}" = [ "Octopi" "${config.resources.aliases.octopi}" ];
  };
}
