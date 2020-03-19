{ config, ... }:

{
  # UEFI
  boot.loader.systemd-boot.enable = true;
  # General settings
  #boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 2;
  # GRUB
  boot.loader.grub = {
    enable = true;
    configurationLimit = 100;
    devices = [ "nodev" ];
    # Install in UEFI mode from device booted in legacy
    #efiInstallAsRemovable = true;
  };
}
