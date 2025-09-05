{ config, ... }:

{
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.efiSupport = true;
}
