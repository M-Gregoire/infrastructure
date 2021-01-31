{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/Mimir
      ../../../vendor/infrastructure-private/resources/hosts/Mimir
      ../../../vendor/infrastructure-private/resources/networks/home/nfs-safe.nix
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/boot/grub-uefi.nix
      ../../dev/boot/grub-multi.nix
      #../../dev/virtualbox.nix
      ../../networks/home
      ../../profiles/PC
      ./../../dev/luks.nix
      #./../../dev/steam.nix
      ./hardware-configuration.nix
    ];

  services.xserver.libinput = {
    # Disable acceleration
    accelProfile = "adaptive";
    accelSpeed = "2";
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.wireless.enable = true;

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.mimir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.mimir.ssh.port ];

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
