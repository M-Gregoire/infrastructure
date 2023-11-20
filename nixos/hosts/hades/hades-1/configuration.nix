# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "hades-1";
      cluster = "hades";
      clusterRole = "server";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  system.stateVersion = "23.05"; # Did you read the comment?

  networking.localCommands = ''
    ${pkgs.ethtool}/bin/ethtool -K eth0 rx off tx off
  '';

  security.sudo.wheelNeedsPassword = false;

  services.k3s.enable = true;

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  fileSystems."/nfs/Data" = {
    device = "/dev/disk/by-uuid/e8cab6fb-29f1-47f4-89d2-6b4ce302534f";
  };

  fileSystems."/nfs/Safe" = {
    device = "/dev/disk/by-uuid/c3a3426a-4421-4cd2-aa05-5e620f4e2fbb";
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Data    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
    /nfs/Safe    192.168.3.30(rw,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
    /nfs/Safe    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

}
