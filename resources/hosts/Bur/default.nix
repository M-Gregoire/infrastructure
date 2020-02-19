{ config, lib,... }:

{
  imports = [
    ../../common.nix
    ../../profiles/PC
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "${config.resources.hosts.bur.hostname}";
    luks.drive = "/dev/disk/by-uuid/9356ad48-c9b4-4724-adc8-d65557c41218";
  };
}
