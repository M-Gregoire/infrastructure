{ config, pkgs, lib, ... }: {
  imports = [
    (import ../../common.nix {
      inherit config pkgs lib;
      hostname = "mimir";
      profile = "PC";
      network = "home";
    })
    ../../dev/linux/bluetooth.nix
    ../../dev/linux/boot/grub-uefi.nix
    ../../dev/linux/boot/grub-multi.nix
    ./../../dev/linux/luks.nix
    ./../../dev/linux/steam.nix
    ./hardware-configuration.nix
    <nixos-hardware/common/cpu/amd>
    <nixos-hardware/common/pc/ssd>
  ];

  services.libinput = {
    # Disable acceleration
    touchpad = {
      accelProfile = "adaptive";
      accelSpeed = "2";
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "gregoire" ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  networking.wireless.enable = false;

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
