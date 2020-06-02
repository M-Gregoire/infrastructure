{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/FenrirDocker
    ../../../vendor/infrastructure-private/resources/hosts/FenrirDocker
    ../../common.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-bios.nix
    ../../../vendor/infrastructure-private/resources/networks/home/nfs-sharkoon.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.fenrirDocker.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.fenrirDocker.ssh.port ];

  system.stateVersion = "20.03";
}
