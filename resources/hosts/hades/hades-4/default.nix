{ config, lib, private-config, ... }:

{
  imports =
    [ "${private-config}/resources/hosts/hades/hades-4" ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
