{ config, lib, ... }:

{
  imports = [ ../../common.nix ../../profiles/PC ];

  config.resources = with lib;
    mapAttrs (_: v: mkDefault v) {
      hostname = "${config.resources.hosts.mimir.hostname}";
      luks.drive = "/dev/disk/by-uuid/74bd5c5b-7619-4d5e-8886-958fdbc8e90d";
      screen = {
        dpi = "96";
        scaleFactor = "1";
      };
    };
}
