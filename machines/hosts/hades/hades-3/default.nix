{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "4d4d52060a764633a155dde81dfb020d";

  system.stateVersion = "20.03";

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    pkgs.k3s
    pkgs.containerd
    pkgs.kubectl

    usb-modeswitch
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  # fileSystems."/nfs/Cameras" = {
  #   device = "/dev/disk/by-uuid/ca58144d-d731-4d1c-a90e-3a49f2424c68";
  #   options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
  # };

  # services.nfs.server.enable = true;
  # services.nfs.server.exports = ''
  #   /nfs         *(rw,fsid=0,no_subtree_check)
  #   /nfs/Cameras *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  # '';

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

}
