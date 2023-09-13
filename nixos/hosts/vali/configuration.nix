{ config, pkgs, lib, ... }:

{
  imports = [
    (import ../../common.nix {
      inherit config pkgs lib;
      hostname = "vali";
      profile = "PC";
      network = "home";
    })
    ../../dev/bluetooth.nix
    ../../dev/suspend.nix
    ../../dev/boot/grub-uefi.nix
    ./../../dev/luks.nix
    ./../../dev/steam.nix
    ./hardware-configuration.nix
    <nixos-hardware/dell/xps/13-9350>
  ];

  config = {
    services.xserver.libinput = {
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
