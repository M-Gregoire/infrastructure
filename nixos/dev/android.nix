{ config, ... }:

{
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
  users.users.${config.resources.host.username}.extraGroups = ["adbusers"];
}
