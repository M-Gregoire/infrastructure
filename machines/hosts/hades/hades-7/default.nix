{ config, pkgs, lib, inputs, flake-root, ... }: {
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

  # mkdir -p /nfs/Cameras && chattr +i /nfs/Cameras
  fileSystems."/nfs/Cameras" = {
    device = "/dev/disk/by-uuid/c78289ef-b0bf-48c0-a17c-02d6f2cbed6c";
    fsType = "ext4";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];
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
