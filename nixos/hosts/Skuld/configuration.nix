{ config, pkgs, ... }:

{
 imports = [
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
    "${config.resources.hosts.eldir}" = [ "Eldir" ];
    "${config.resources.hosts.rind}" = [ "Rind" ];
  };

  networking.firewall.allowedTCPPorts = [
    # deconz REST API
    80
    # deconz websockets
    443
    # leon-ai
    1337
    # prometheus
    9090
    # blackbox exporter
    9115
    # grafana
    3000
    # home assistant
    8123
    # OpenVPN
    1194
    # Mosquitto MQTT broker
    1883
    9001
  ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = false;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  system.stateVersion = "18.09";
}
