{ config, lib, ... }:

{
  imports = [ ../../../vendor/infrastructure-private/resources/hosts/eldir ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
