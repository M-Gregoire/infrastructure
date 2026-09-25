{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  environment.etc."machine-id".text = "3fe6c883e941417bae469e646b7946cf";

  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

  security.sudo.wheelNeedsPassword = false;

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
      # Cap per-container log rotation so steady-state usage stays well under
      # the /var/log/pods tmpfs budget (see hades/default.nix).
      "--kubelet-arg=container-log-max-size=5Mi"
      "--kubelet-arg=container-log-max-files=2"
    ];
  };

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.nfs.server.enable = true;
  # /nfs/Harbor    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
  '';

}
