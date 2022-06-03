{ config, lib, pkgs, ... }:

{
  services.k3s.enable = true;
  services.k3s.role = "server";
  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];
}
