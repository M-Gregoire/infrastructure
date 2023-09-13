{ config, pkgs, lib, ... }: {
  imports = [
    (import ../../common.nix {
      inherit config pkgs lib;
      hostname = "mimir";
      profile = "PC";
      network = "home";
    })
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-uefi.nix
    ../../dev/boot/grub-multi.nix
    ./../../dev/luks.nix
    ./../../dev/steam.nix
    ./hardware-configuration.nix
  ];

  services.xserver.libinput = {
    # Disable acceleration
    touchpad = {
      accelProfile = "adaptive";
      accelSpeed = "2";
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.wireless.enable = false;

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
