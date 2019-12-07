{ config, pkgs, ... }:

{
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = config.resources.luks.drive;
      preLVM = true;
    }
  ];
}
