{ config, lib, pkgs, ... }:

{
  imports = [ ../../dev/systemd-networkd.nix ];

  boot.kernelModules = [ "nbd" "rbd" "ceph" ];
}
