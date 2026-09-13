{ config, pkgs, lib, inputs, ... }:

{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "654a6237228845aa85f7ecfcd1e077cd";

  system.stateVersion = "20.03";

  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
    # hades-4's root filesystem lives on a Realtek RTL9210 M.2 NVMe adapter
    # (0bda:9210, USB bus 1-1.2) that resets/disconnects under UAS roughly
    # hourly (306 disconnects / 35 resets over 13 days in Datadog logs). On
    # 2026-09-09 a disconnect landed mid-write, aborting the ext4 journal and
    # remounting "/" read-only, which took the node down. Forcing plain USB
    # Mass Storage (no UAS) for this exact device is the standard fix for
    # RTL9210 instability. This device ID is unique to hades-4 in the fleet
    # (checked: no other hades node has 0bda:9210), so this is scoped here
    # rather than the shared hades/default.nix.
    "usb-storage.quirks=0bda:9210:u"
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
}
