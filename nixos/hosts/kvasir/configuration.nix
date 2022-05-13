{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/kvasir
    ../../../vendor/infrastructure-private/resources/hosts/kvasir
    ../../common.nix
    ../../dev/k3s.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-bios.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts =
    [ config.resources.hosts.kvasir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.kvasir.ssh.port ];

  system.stateVersion = "20.03";
  networking.firewall.enable = false;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

}
