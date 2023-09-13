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

  system.activationScripts = {
    nfs-folder.text = ''
      mkdir -p /nfs/Safe
    '';
  };

  fileSystems."/nfs/Safe" = {
    device = "/dev/disk/by-uuid/c3a3426a-4421-4cd2-aa05-5e620f4e2fbb";
    fsType = "ext4";
    # options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
    options =
      [ "noauto" "nofail" "x-systemd.automount" "x-systemd.device-timeout=30" ];
  };

  services.k3s.enable = true;

  environment.systemPackages =
    [ pkgs.k3s pkgs.containerd pkgs.kubectl pkgs.usb-modeswitch ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.udev.extraRules = ''
    # Get info with udevadm info --attribute-walk /dev/tty...
    # If Modem in USB Storage mode, switch to 3G mode
    # Requires `usb-modeswitch`
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="15ca", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 12d1 -p 15ca -M '55534243123456780000000000000011062000000100000000000000000000'"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", RUN+="${pkgs.bash}/bin/bash -c 'modprobe option && echo 12d1 1506 > /sys/bus/usb-serial/drivers/option1/new_id'"

    # If Modem in 3G mode, make alias named ttyUSB-Huawei-3G
    SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", SYMLINK+="ttyUSB-Huawei-3G"
  '';

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Safe    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';
}
