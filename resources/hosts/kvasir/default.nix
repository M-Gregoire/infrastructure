{ config, lib, ... }:

{
  imports = [ ../../../vendor/infrastructure-private/resources/hosts/kvasir ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
