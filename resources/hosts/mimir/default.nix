{ config, lib, private-config, ... }:

{
  imports = [ "${private-config}/resources/hosts/mimir" ];

  config.resources = with lib;
    mapAttrs (_: v: mkDefault v) {
      luks.drive = "/dev/disk/by-uuid/74bd5c5b-7619-4d5e-8886-958fdbc8e90d";
      screen = {
        dpi = "96";
        scaleFactor = "1";
      };
    };
}
