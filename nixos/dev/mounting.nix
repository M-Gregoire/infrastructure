{ config, ... }:

{
  services.gvfs.enable = true;
  services.devmon.enable = false;
  services.udisks2.enable = true;
}
