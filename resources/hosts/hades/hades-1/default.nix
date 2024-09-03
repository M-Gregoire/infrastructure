{ config, lib, private-config, ... }:

{
  imports = [
    ../default.nix

    "${private-config}/resources/hosts/hades/hades-1"
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
