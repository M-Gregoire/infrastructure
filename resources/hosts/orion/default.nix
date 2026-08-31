{ config, lib, ... }:

{
  config.resources = with lib; mapAttrs (_: v: mkDefault v) { };
}
