{ config, pkgs, ... }:

{
  networking.hosts = {
    "${config.resources.hosts.beyla.ip}" = [ "Beyla" "${config.resources.hosts.beyla.alias}" ];
    "${config.resources.hosts.octopi.ip}" = [ "Octopi" "${config.resources.hosts.octopi.alias}" ];
  };
}
