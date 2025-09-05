{ config, lib, private-config, ... }:

{
  imports = [ ../default.nix ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
