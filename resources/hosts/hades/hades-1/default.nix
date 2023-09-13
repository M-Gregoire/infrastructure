{ config, lib, ... }:

{
  imports = [
    ../default.nix

    ../../../../vendor/infrastructure-private/resources/hosts/hades/hades-1
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
