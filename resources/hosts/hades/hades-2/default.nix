{ config, lib, private-config, ... }:

{
  imports =
    [ "${private-config}/resources/hosts/hades/hades-2" ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
