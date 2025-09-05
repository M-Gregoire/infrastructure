{ config, lib, ... }:

let
  dhcpConfig = { UseDNS = true; };
  networkConfig = {
    DHCP = "yes";
    MulticastDNS = "resolve";
  };
  linkConfig = { RequiredForOnline = true; };
in {
  networking.useNetworkd = true;
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;

  services.resolved.enable = true;
  services.resolved.dnssec = "false";
  networking.resolvconf.dnsExtensionMechanism = false;
  services.resolved.fallbackDns = config.resources.networking.fallbackDNS;

  # /!\ DNS fallback is not a recovery DNS
  # See https://github.com/systemd/systemd/issues/5771#issuecomment-296673115
  # services.resolved.extraConfig = ''
  #   FallbackDNS=${
  #     builtins.concatStringsSep " " config.resources.networking.fallbackDNS
  #   }
  # '';

  # Add search domain
  # services.resolved.domains = config.resources.networking.searchDomains;

  # Based on https://github.com/NixOS/nixpkgs/issues/30904#issuecomment-445073924
  # If two ethernet ports are present but only one is plugged in, wait-online would fail
  # Any allows for wait-online service to be running as soon as one LAN interface is configured
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  # TODO: Investigate routing table
  # systemd.network.networks."10-physical" = {
  #   linkConfig.RequiredForOnline = true;
  #   #dhcpConfig.RouteTable = 2468;
  #   dhcpConfig.UseDNS = true;
  #   matchConfig.Name = "en* eth* wl*";
  #   networkConfig.DHCP = "yes";
  #   networkConfig.MulticastDNS= "resolve";
  # };

  systemd.network.networks."20-wired" = {
    matchConfig.Name = "en* eth*";
    networkConfig = networkConfig;
    dhcpConfig = lib.mkMerge dhcpConfig { RouteMetric = "10"; };
    linkConfig = linkConfig;
  };

  systemd.network.networks."25-wireless" = {
    matchConfig.Name = "wl*";
    networkConfig = networkConfig;
    dhcpConfig = lib.mkMerge dhcpConfig { RouteMetric = "20"; };
    linkConfig = linkConfig;
  };

  systemd.network.networks."30-virtualisation" = {
    matchConfig.Name = "*";
    # matchConfig.Name =
    #   "virbr* veth* vboxnet* docker* br-* hassio cni* flannel*";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
