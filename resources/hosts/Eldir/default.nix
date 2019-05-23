{ config, lib,... }:

{
  imports = [
    ../../common.nix
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    host.name = "Eldir";
  };
}
