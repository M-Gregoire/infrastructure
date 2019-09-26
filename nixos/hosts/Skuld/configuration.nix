{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/Skuld
    ../../../vendor/infrastructure-private/resources/hosts/Skuld
    ../../common.nix
    ../../dev/bluetooth.nix
    ../../dev/nfs.nix
    ../../dev/wireguard-server.nix
    ../../networks/home
    ../../profiles/Server
    ../../systemd-boot.nix
    ./hardware-configuration.nix
    ./mail-server.nix
  ];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.skuld.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.skuld.ssh.port ];

  networking.hosts = {
    # This part is used to define custom DNS records by my Octopi
    "${config.resources.hosts.bur.ip.default}" = [ "Bur" "${builtins.concatStringsSep " " config.resources.hosts.bur.extraDomains}" ];
    "${config.resources.hosts.eldir.ip.default}" = [ "Eldir" "${builtins.concatStringsSep " " config.resources.hosts.eldir.extraDomains}" ];
    "${config.resources.hosts.idunn.ip.default}" = [ "Idunn" "${builtins.concatStringsSep " " config.resources.hosts.idunn.extraDomains}" ];
    "${config.resources.hosts.mimir.ip.default}" = [ "Mimir" "${builtins.concatStringsSep " " config.resources.hosts.mimir.extraDomains}" ];
    # Basic hostname already defined in the home profile
    "${config.resources.hosts.beyla.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.beyla.extraDomains}" ];
    "${config.resources.hosts.octopi.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.octopi.extraDomains}" ];
    # Basic hostname binded to localhost
    "${config.resources.hosts.skuld.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.skuld.extraDomains}" ];
  } // config.resources.hosts.extra;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = false;

  system.stateVersion = "18.09";
}
