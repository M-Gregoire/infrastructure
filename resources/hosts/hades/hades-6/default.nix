{ config, lib, ... }:

{
  imports =
    [ ../../../../vendor/infrastructure-private/resources/hosts/hades/hades-6 ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
