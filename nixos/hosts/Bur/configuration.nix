{ config, pkgs, ... }:

{
  imports =
    [
      ../../common.nix
      ../../grub.nix
      ../../profiles/PC
      ../../dev/suspend.nix
      ../../dev/bluetooth.nix
      ./hardware-configuration.nix
      ../../networks/home
      ../../../resources/hosts/Bur
      ../../../vendor/infrastructure-private/resources/hosts/Bur
      ../../../luks.nix
    ];

  services.xserver.libinput = {
   # Enable tapping
    tapping = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "19.03";
}
