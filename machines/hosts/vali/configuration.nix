{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../dev/linux/bluetooth.nix
    ../../dev/linux/suspend.nix
    ../../dev/linux/boot/grub-uefi.nix
    ./../../dev/linux/luks.nix
    ./../../dev/linux/steam.nix
    ./hardware-configuration.nix
  ];

  config = {
    services.libinput = {
      # Enable tapping
      enable = true;
      touchpad = {
        tapping = true;
        accelProfile = "adaptive";
        accelSpeed = "2";
      };
    };

    services.xserver.monitorSection = ''
      DisplaySize 162 91
    '';

    networking.wireless = {
      enable = true;
      interfaces = [ "wlp58s0" ];
    };

    boot.loader.grub.efiSupport = true;

    system.stateVersion = "20.03";

  };
}
