{ config, lib, ... }:

{
  imports =
    [ ../../../../vendor/infrastructure-private/resources/hosts/hades/hades-5 ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
