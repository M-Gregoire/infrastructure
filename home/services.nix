{ pkgs, lib, config, ... }:

{
  services.udiskie.enable = true;

  services.syncthing.enable = true;
}
