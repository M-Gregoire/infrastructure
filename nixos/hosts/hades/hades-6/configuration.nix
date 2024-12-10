{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib inputs;
      hostname = "hades-6";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "dcf8a7751aa94acab1e61bb6edb85ece";

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

  # mkdir -p /nfs/Cameras && chattr +i /nfs/Cameras
  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/5e2b8ebc-270f-4df8-82a4-008ca38e0b4f";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Cameras    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = "";

  # Increase GPU mem for Frigate
  # https://docs.frigate.video/configuration/hardware_acceleration/#raspberry-pi-34
  # boot.loader.raspberryPi = {
  #   enable = true;
  #   firmwareConfig = ''
  #     gpu_mem=128
  #   '';
  # };
}
