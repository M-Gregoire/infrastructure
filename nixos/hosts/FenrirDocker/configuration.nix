{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/FenrirDocker
    ../../../vendor/infrastructure-private/resources/hosts/FenrirDocker
    ../../common.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-bios.nix
    ../../dev/nfs.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.fenrirDocker.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.fenrirDocker.ssh.port ];

  # Unifi
  services.unifi.enable = true;

  system.stateVersion = "19.03";
}
