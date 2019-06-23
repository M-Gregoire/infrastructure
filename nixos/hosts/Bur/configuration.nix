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
    ];

  # Servers are defined in profile, only home network should be defined here
  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
    "${config.resources.hosts.mimir}" = [ "Mimir" ];
  };

  services.xserver.libinput = {
   # Enable tapping
    tapping = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "19.03";
}
