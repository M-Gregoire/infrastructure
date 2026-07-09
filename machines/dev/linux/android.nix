{ config, pkgs, ... }:

{
  nixpkgs.config.android_sdk.accept_license = true;
  environment.systemPackages = [ pkgs.android-tools ];
  users.users.${config.resources.username}.extraGroups = [ "adbusers" ];
}
