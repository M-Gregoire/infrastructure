{ config, pkgs, ... }:

{
  # Standalone K3s server profile (not used by the Hades cluster).
  # Hades has its own per-node K3s configuration under machines/hosts/hades/.
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = builtins.concatStringsSep " " [
      "--disable servicelb"
      "--kubelet-arg=runtime-request-timeout=5m0s"
      "--tls-san ${config.resources.hostname}.${config.resources.networking.domain}"
    ];
  };

  environment.systemPackages = [
    pkgs.k3s
    pkgs.containerd
    pkgs.kubectl
  ];
  networking.firewall.allowedTCPPorts = [ 6443 ];
}
