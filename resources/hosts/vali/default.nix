{ config, lib,... }:

{
  imports = [
    ../../common.nix
    ../../profiles/PC
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    hostname = "${config.resources.hosts.vali.hostname}";
    luks.drive = "/dev/nvme0n1p2";
  };
}
