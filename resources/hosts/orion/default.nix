{ config, lib, private-config, ... }:

{
  imports = [ "${private-config}/resources/hosts/orion" ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
