{ config, pkgs, lib, ... }:

{
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "hades-6";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
    <nixos-hardware/raspberry-pi/4>
    <home-manager/nixos>
  ];

  system.stateVersion = "20.03";

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    k3s
    containerd
    kubectl
    usb-modeswitch
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  fileSystems."/nfs/Safe" = {
    device = "/dev/disk/by-uuid/c3a3426a-4421-4cd2-aa05-5e620f4e2fbb";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Safe    192.168.3.30(rw,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
    /nfs/Safe    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = "";

}
