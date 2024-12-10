{ config, lib, pkgs, ... }:
with lib; {
  config = {
    services.k3s.enable = true;
    services.k3s.role = "server";

    # TODO: Investigate why DiskPressure without this
    services.k3s.extraFlags =
      "--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1% --kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1% --kubelet-arg=runtime-request-timeout=5m0s --tls-san ${config.resources.hostname}.${config.resources.networking.domain}";

    environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
    networking.firewall.allowedTCPPorts = [ 6443 ];
  };
}
