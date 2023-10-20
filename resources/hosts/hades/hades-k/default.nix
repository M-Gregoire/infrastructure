{ config, lib, ... }:

{
  imports =
    [ ../../../../vendor/infrastructure-private/resources/hosts/hades/hades-k ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
