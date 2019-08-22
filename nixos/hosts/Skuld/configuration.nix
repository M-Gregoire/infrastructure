{ config, pkgs, ... }:

{
 imports = [
    ./services.nix
    ../../common.nix
    ../../systemd-boot.nix
    ./hardware-configuration.nix
    ./mail-server.nix
    #./../../dev/wireguard-server.nix
    ../../networks/home
    ../../profiles/Server
    ../../../resources/hosts/Skuld
    ../../../vendor/infrastructure-private/resources/hosts/Skuld
  ];

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
    "${config.resources.hosts.eldir.ip}" = [ "Eldir" ];
    "${config.resources.hosts.rind.ip}" = [ "Rind" ];
  };

  networking.firewall.allowedTCPPorts = config.resources.hosts.skuld.openPorts;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = false;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  system.stateVersion = "18.09";
}
