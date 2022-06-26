{ config, ... }:

{
  # General settings
  #boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.timeout = 2;
  # GRUB
  boot.loader.grub = {
    enable = true;
    configurationLimit = 100;
    devices = [ "nodev" ];
    # Install the EFI entry in /EFI/BOOT/BOOTX64.EFI instead of /EFI/NixOS-boot/
    # This is to prevent unacessible NixOS in case of UEFI reset
    efiInstallAsRemovable = true;
  };
}
