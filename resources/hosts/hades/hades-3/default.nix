{ config, lib, private-config, ... }:

{
  imports =
    [ "${private-config}/resources/hosts/hades/hades-3" ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
