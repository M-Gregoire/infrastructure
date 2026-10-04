{ config, pkgs, ... }:

{
  boot.initrd.systemd.enable = true;

  boot.initrd.luks.devices = {
    root = {
      device = config.resources.luks.drive;
      preLVM = true;
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };
}
