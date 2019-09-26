{ config, lib,... }:

{
  imports = [
    ../../common.nix
    ../../profiles/PC
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "Mimir";
  };
}
