{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../../dev/linux/bluetooth.nix
    ../../dev/linux/boot/grub-uefi.nix
    ../../dev/linux/boot/grub-multi.nix
    ./../../dev/linux/luks.nix
    ./../../dev/linux/steam.nix
    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "c4e9716cfd684ec1ad9c70b7b0dabe2a";

  services.libinput = {
    # Disable acceleration
    touchpad = {
      accelProfile = "adaptive";
      accelSpeed = "2";
    };
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "gregoire" ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  # Disable autosuspend which seems to mess with KVM switch
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  networking.wireless.enable = false;

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
