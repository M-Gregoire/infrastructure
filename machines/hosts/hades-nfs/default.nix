# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../dev/datadog.nix
  ];

  environment.etc."machine-id".text = "4fe6c883e941417bae469e646b7946ab";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  system.stateVersion = "23.05"; # Did you read the comment?

  networking.firewall.allowedTCPPorts = [ 2049 ];

  security.sudo.wheelNeedsPassword = false;

  # mkdir -p /nfs/Kodi && chattr +i /nfs/Kodi
  fileSystems."/nfs/Kodi" = {
    device = "/dev/disk/by-uuid/160eb233-cb31-43bb-b2be-1836ed18d3d2";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };
  # mkdir -p /nfs/Safe && chattr +i /nfs/Safe
  fileSystems."/nfs/Safe" = {
    device = "/dev/disk/by-uuid/c3a3426a-4421-4cd2-aa05-5e620f4e2fbb";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Kodi    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
    /nfs/Safe    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

}
