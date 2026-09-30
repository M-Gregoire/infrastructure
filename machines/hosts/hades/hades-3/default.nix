{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "4d4d52060a764633a155dde81dfb020d";

  system.stateVersion = "20.03";

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
    # Cap per-container log rotation so steady-state usage stays well under
    # the /var/log/pods tmpfs budget (see hades/default.nix).
    extraFlags = lib.concatStringsSep " " [
      "--kubelet-arg=container-log-max-size=5Mi"
      "--kubelet-arg=container-log-max-files=2"
    ];
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
}
