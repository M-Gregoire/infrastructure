{
  config,
  pkgs,
  lib,
  inputs,
  flake-root,
  ...
}:
{
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "dcf8a7751aa94acab2d61bb6edb85ece";

  system.stateVersion = "20.03";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    k3s
    containerd
    kubectl
  ];

  services.k3s = {
    enable = true;
    extraFlags = lib.concatStringsSep " " [
      "--disable servicelb"
      "--kube-apiserver-arg=default-not-ready-toleration-seconds=30"
      "--kube-apiserver-arg=default-unreachable-toleration-seconds=30"
      "--kube-controller-manager-arg=node-monitor-grace-period=30s"
      "--kube-controller-manager-arg=terminated-pod-gc-threshold=100"
      "--tls-san ${config.resources.hostname}.${config.resources.networking.domain}"
      "--tls-san 192.168.3.60"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

  # Protect mount point: if the disk is missing or unmounted, the immutable
  # flag prevents anything from writing to the root filesystem.
  # mount(2) operates at VFS level and is unaffected by the flag.
  system.activationScripts.protectNfsMounts = lib.stringAfter [ "specialfs" ] ''
    mkdir -p /nfs/Cameras
    ${pkgs.e2fsprogs}/bin/chattr +i /nfs/Cameras
  '';

  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/cd3bfbfb-37a3-4b14-82a8-be42e5b31610";
    fsType = "ext4";
    options = [
      "auto"
      "nofail"
      "x-systemd.device-timeout=30"
    ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Cameras    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

  services.udev.extraRules = ''
    # Make alias for zigbee
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="0001", SYMLINK+="ttyUSB-Sonoff-Zigbee"
  '';
}
