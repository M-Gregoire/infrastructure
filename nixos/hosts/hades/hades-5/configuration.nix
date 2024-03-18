{ config, pkgs, lib, ... }:

{
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib;
      hostname = "hades-5";
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

  services.udev.extraRules = "";

}
