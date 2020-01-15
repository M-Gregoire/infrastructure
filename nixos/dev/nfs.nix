{ config, pkgs, ... }:

{
  boot.kernelModules = [ "nfs" "nfsd" ];

  environment.systemPackages = with pkgs; [
    # NFS
    nfs-utils
  ];

  boot.kernelParams = [
    # https://www.suse.com/support/kb/doc/?id=7014266
    "nfs.nfs4_disable_idmapping=1"
  ];
}
