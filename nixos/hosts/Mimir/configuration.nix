{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/Mimir
      ../../../vendor/infrastructure-private/resources/hosts/Mimir
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/steam.nix
      ../../dev/virtualbox.nix
      ../../grub.nix
      ../../networks/home
      ../../profiles/PC
      ./hardware-configuration.nix
    ];

  services.xserver.libinput.accelSpeed = null;

  services.xserver.videoDrivers = [ "amdgpu" ];

  boot.kernelParams = [
    # Fix "Start save/load RF Kill switch" error on boot with amdgpu
    "iommu=soft"
    # Fix boot hanging on "Reached target local file"
    #"amdgpu.dc=0"
    "radeon.si_support=0"
    "radeon.cik_support=0"
    # https://wiki.gentoo.org/wiki/AMDGPU
    "amdgpu.si_support=0"
    "amdgpu.cik_support=1"
  ];

  # Servers are defined in profile, only home network should be defined here
  networking.hosts = {
    "${config.resources.hosts.bur.ip.default}" = [ "Bur" ];
  };

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.mimir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.mimir.ssh.port ];

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "19.09";
}
