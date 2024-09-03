{ config, pkgs, lib, private-config, ... }:

{
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib private-config;
      hostname = "hades-6";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
    <nixos-hardware/raspberry-pi/4>
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

  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/ca58144d-d731-4d1c-a90e-3a49f2424c68";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Cameras    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = "";

}
