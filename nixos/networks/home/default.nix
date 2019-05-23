{ config, pkgs, ... }:

{
  networking.hosts = {
    "${config.resources.hosts.beyla}" = [ "Beyla" ];
  };
}
