{ config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  environment.etc."machine-id".text = "3fe6c883e941417bae469e646b7946cf";

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  system.stateVersion = "23.05"; # Did you read the comment?

  security.sudo.wheelNeedsPassword = false;

  services.k3s.enable = true;

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  # mkdir -p /nfs/Data && chattr +i /nfs/Data
  fileSystems."/nfs/Data" = {
    device = "/dev/disk/by-uuid/beee5400-19ac-43d6-8d0f-4a3d87e8ce6d";
    options = [ "auto" "nofail" "x-systemd.device-timeout=30" ];

  };

  services.nfs.server.enable = true;
  # /nfs/Harbor    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  services.nfs.server.exports = ''
    /nfs         *(rw,fsid=0,no_subtree_check)
    /nfs/Data    *(rw,no_subtree_check,no_root_squash,anonuid=1000,anongid=1000)
  '';

}
