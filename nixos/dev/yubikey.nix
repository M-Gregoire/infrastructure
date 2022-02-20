{ config, lib, pkgs, ... }:

{
  services.udev.packages = [ pkgs.yubikey-personalization ];
}
