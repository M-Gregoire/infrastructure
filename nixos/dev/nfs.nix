{ config, ... }:

{
  boot.kernelModules = [ "nfs" "nfsd" ];
}
