{ config, lib,... }:

{
  imports = [
    ../../common.nix
    ../../profiles/PC
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "${config.resources.hosts.mimir.hostname}";
    luks.drive = "/dev/disk/by-uuid/c734259d-b1a8-449e-a991-ace9d6f561ed";
    screen = {
      dpi = "96";
      scaleFactor = "1";
    };
  };
}
