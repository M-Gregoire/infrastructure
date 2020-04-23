{ config, pkgs, ... }:

{
  boot.initrd.luks.devices = {
    root = {
      device = config.resources.luks.drive;
      preLVM = true;
    };
  };
}
