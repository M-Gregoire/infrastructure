{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/Mimir
      ../../../vendor/infrastructure-private/resources/hosts/Mimir
      ../../../vendor/infrastructure-private/resources/networks/home/nfs-sharkoon.nix
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/boot/grub-uefi.nix
      ../../dev/boot/grub-multi.nix
      ../../dev/virtualbox.nix
      ../../networks/home
      ../../profiles/PC
      ./../../dev/luks.nix
      ./hardware-configuration.nix
    ];

  # Unifi
  services.unifi.enable = true;

  services.xserver.libinput.accelSpeed = null;

  networking.wireless.enable = true;

  #services.xserver.videoDrivers = [ "amdgpu" ];
  #boot.kernelParams = [
  #  # Fix "Start save/load RF Kill switch" error on boot with amdgpu
  #  "iommu=soft"
  #  # Fix boot hanging on "Reached target local file"
  #  #"amdgpu.dc=0"
  #  "radeon.si_support=0"
  #  "radeon.cik_support=0"
  #  # https://wiki.gentoo.org/wiki/AMDGPU
  #  "amdgpu.si_support=0"
  #  "amdgpu.cik_support=1"
  #];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.mimir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.mimir.ssh.port ];

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
