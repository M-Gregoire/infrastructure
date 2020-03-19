{ config, lib,... }:

{
  imports = [
    ../../common.nix
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "${config.resources.hosts.skuld.hostname}";
  };
}
