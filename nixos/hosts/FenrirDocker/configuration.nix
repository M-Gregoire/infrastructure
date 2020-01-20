{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/FenrirDocker
    ../../../vendor/infrastructure-private/resources/hosts/FenrirDocker
    ../../common.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-bios.nix
    ../../dev/nfs.nix
    ../../dev/wireguard-server.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.fenrirDocker.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.fenrirDocker.ssh.port ];

  # Unifi
  services.unifi.enable = true;

  fileSystems."/nfs/Sharkoon" = {
    device = "fenrirNas.martinache.net:/mnt/Sharkoon";
    fsType = "nfs";
    options = [ "defaults" ];#"uid=1000" "gid=1000" "umask=002" ];
  };

  networking.hosts = {
    # This part is used to define custom DNS records by my PiHole
    "${config.resources.hosts.bur.ip.default}" = [ "Bur" "${builtins.concatStringsSep " " config.resources.hosts.bur.extraDomains}" ];
    "${config.resources.hosts.eldir.ip.default}" = [ "Eldir" "${builtins.concatStringsSep " " config.resources.hosts.eldir.extraDomains}" ];
    "${config.resources.hosts.idunn.ip.default}" = [ "Idunn" "${builtins.concatStringsSep " " config.resources.hosts.idunn.extraDomains}" ];
    "${config.resources.hosts.mimir.ip.default}" = [ "Mimir" "${builtins.concatStringsSep " " config.resources.hosts.mimir.extraDomains}" ];
    "${config.resources.hosts.skuld.ip.default}" = [ "Skuld" "${builtins.concatStringsSep " " config.resources.hosts.skuld.extraDomains}" ];
    # Basic hostname already defined in the home profile
    "${config.resources.hosts.beyla.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.beyla.extraDomains}" ];
    "${config.resources.hosts.octopi.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.octopi.extraDomains}" ];
    # Basic hostname binded to localhost
    "${config.resources.hosts.fenrirDocker.ip.default}" = [ "${builtins.concatStringsSep " " config.resources.hosts.fenrirDocker.extraDomains}" ];
  } // config.resources.hosts.extra;

  system.stateVersion = "19.03";
}
