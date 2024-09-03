# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, private-config, ... }:

{
  imports = [ # Include the results of the hardware scan.
    (import ../../../common.nix {
      inherit config pkgs lib private-config;
      hostname = "hades-1";
      cluster = "hades";
      clusterRole = "server";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  system.stateVersion = "23.05"; # Did you read the comment?

  # networking.localCommands = ''
  #   ${pkgs.ethtool}/bin/ethtool -K eth0 rx off tx off
  # '';

  security.sudo.wheelNeedsPassword = false;

  services.k3s.enable = true;

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  fileSystems."/nfs/Data" = {
    device = "/dev/disk/by-uuid/e8cab6fb-29f1-47f4-89d2-6b4ce302534f";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];

  };

  fileSystems."/nfs/Harbor" = {
    device = "/dev/disk/by-uuid/26b0657b-b71f-4d51-b1b6-06216e0fd6c9";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Harbor    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
    /nfs/Data    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

}
