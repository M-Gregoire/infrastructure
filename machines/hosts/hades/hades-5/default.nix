{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "";

  system.stateVersion = "20.03";

  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

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
    # Cap per-container log rotation so steady-state usage stays well under
    # the /var/log/pods tmpfs budget (see hades/default.nix).
    extraFlags = lib.concatStringsSep " " [
      "--kubelet-arg=container-log-max-size=5Mi"
      "--kubelet-arg=container-log-max-files=2"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.udev.extraRules = "";

}
