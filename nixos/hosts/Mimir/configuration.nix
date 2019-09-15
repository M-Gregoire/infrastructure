{ config, pkgs, ... }:

{
  imports =
    [
      ../../common.nix
      ../../grub.nix
      ./hardware-configuration.nix
      ../../dev/steam.nix
      ../../dev/bluetooth.nix
      ../../profiles/PC
      ../../../resources/hosts/Mimir
      ../../networks/home
      ../../../vendor/infrastructure-private/resources/hosts/Mimir
    ];

  services.xserver.libinput.accelSpeed = null;

  # Servers are defined in profile, only home network should be defined here
  networking.hosts = {
    "${config.resources.hosts.bur.ip}" = [ "Bur" ];
  };

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  virtualisation.virtualbox.host.enable = true;
  users.extraUsers."${config.resources.host.username}".extraGroups = ["vboxusers"];

  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "19.03";
}
