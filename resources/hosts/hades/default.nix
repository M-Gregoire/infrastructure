{ pkgs, config, lib, clusterRole, ... }:

{
  imports = [ ];

  config.resources = with lib;
    mapAttrs (_: v: mkDefault v) {
      # hostname = "${config.resources.hosts.eldir.hostname}";
    };
}
