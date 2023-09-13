{ config, lib, ... }:

{
  imports = [ ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
