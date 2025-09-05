{ config, pkgs, ... }:

{
  boot.kernelModules = [ "nfs" "nfsd" ];

  environment.systemPackages = with pkgs;
    [
      # NFS
      nfs-utils
    ];
}
