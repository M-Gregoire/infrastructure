{ config, lib, ... }:

{
  imports = [
    ../../../../vendor/infrastructure-private/resources/hosts/apollon/apollon-1
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
