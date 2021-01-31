{ config, lib,... }:

{
  imports = [
    ../../common.nix
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "${config.resources.hosts.fenrirDocker.hostname}";
  };

  config.environment.variables."COMPOSE_HTTP_TIMEOUT" = "600";

}
