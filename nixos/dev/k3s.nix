{ config, lib, pkgs, ... }:

{
  services.k3s.enable = true;
  services.k3s.role = "server";

  # TODO: Investigate why DiskPressure without this
  services.k3s.extraFlags =
    "--kubelet-arg=eviction-hard=imagefs.available<1%,nodefs.available<1% --kubelet-arg=eviction-minimum-reclaim=imagefs.available=1%,nodefs.available=1%";

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];
}
