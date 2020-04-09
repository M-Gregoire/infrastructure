{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/Skuld
    ../../../vendor/infrastructure-private/resources/hosts/Skuld
    ../../common.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/systemd-boot.nix
    ../../dev/nfs.nix
    ../../dev/wireguard-server.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.skuld.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.skuld.ssh.port ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = false;

  system.stateVersion = "18.09";
}
