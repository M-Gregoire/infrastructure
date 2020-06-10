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

  services.xserver.libinput.accelSpeed = null;

  networking.wireless.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/86212#issuecomment-640232588
  hardware.opengl.package = (import (pkgs.fetchzip {
    name = "old-nixpkgs";
    url = "https://github.com/NixOS/nixpkgs/archive/0a11634a29c1c9ffe7bfa08fc234fef2ee978dbb.tar.gz";
    sha256 = "0vj5k3djn1wlwabzff1kiiy3vs60qzzqgzjbaiwqxacbvlrci10y";
  }) {}).mesa.drivers;

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.mimir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.mimir.ssh.port ];

  environment.systemPackages = with pkgs; [ numlockx glxinfo ];
  services.xserver.displayManager.lightdm.extraSeatDefaults = ''
    greeter-setup-script=${pkgs.numlockx}/bin/numlockx on
  '';

  system.stateVersion = "20.03";
}
