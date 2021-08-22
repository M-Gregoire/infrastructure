{ config, ... }:

{
  nixpkgs.config.android_sdk.accept_license = true;
  programs.adb.enable = true;
  users.users.${config.resources.username}.extraGroups = [ "adbusers" ];

  services.gvfs.enable = true;
}
