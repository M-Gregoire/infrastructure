{ config, lib, private-config, ... }:

{

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
