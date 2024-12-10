{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib inputs;
      hostname = "hades-5";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "";

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
