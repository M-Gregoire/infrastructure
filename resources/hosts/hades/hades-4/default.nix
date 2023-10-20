{ config, lib, ... }:

{
  imports =
    [ ../../../../vendor/infrastructure-private/resources/hosts/hades/hades-4 ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
