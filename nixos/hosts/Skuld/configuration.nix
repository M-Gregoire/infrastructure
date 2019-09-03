{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/Skuld
    ../../../vendor/infrastructure-private/resources/hosts/Skuld
    ../../common.nix
    ../../dev/nfs.nix
    ../../networks/home
    ../../profiles/Server
    ../../systemd-boot.nix
    ./hardware-configuration.nix
    ./mail-server.nix
    ./services.nix
  ];

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
    # This part is used to define custom DNS records by my Octopi
    "${config.resources.hosts.bur.ip}" = [ "Bur" "${builtins.concatStringsSep " " config.resources.hosts.bur.extraDomains}" ];
    "${config.resources.hosts.eldir.ip}" = [ "Eldir" "${builtins.concatStringsSep " " config.resources.hosts.eldir.extraDomains}" ];
    "${config.resources.hosts.idunn.eth.ip}" = [ "Idunn" "${builtins.concatStringsSep " " config.resources.hosts.idunn.extraDomains}" ];
    "${config.resources.hosts.mimir.ip}" = [ "Mimir" "${builtins.concatStringsSep " " config.resources.hosts.mimir.extraDomains}" ];
    "${config.resources.hosts.rind.ip}" = [ "Rind" "${builtins.concatStringsSep " " config.resources.hosts.rind.extraDomains}" ];
    # Basic hostname already defined in the home profile
    "${config.resources.hosts.beyla.ip}" = [ "${builtins.concatStringsSep " " config.resources.hosts.beyla.extraDomains}" ];
    "${config.resources.hosts.octopi.ip}" = [ "${builtins.concatStringsSep " " config.resources.hosts.octopi.extraDomains}" ];
    # Basic hostname binded to localhost
    "${config.resources.hosts.skuld.ip}" = [ "${builtins.concatStringsSep " " config.resources.hosts.skuld.extraDomains}" ];
  };

  networking.firewall.allowedTCPPorts = config.resources.hosts.skuld.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.hosts.skuld.openUDPPorts;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = false;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  system.stateVersion = "18.09";
}
