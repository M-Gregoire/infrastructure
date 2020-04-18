{ config, ... }:

{
  networking.dhcpcd.enable = false;

  networking.useNetworkd = true;

  networking.useDHCP = false;

  services.resolved.enable = true;
  # /!\ DNS fallback is not a recovery DNS
  # See https://github.com/systemd/systemd/issues/5771#issuecomment-296673115
  services.resolved.extraConfig = ''
  FallbackDNS=${builtins.concatStringsSep " " config.resources.networking.fallbackDNS}
  '';
  services.resolved.dnssec="false";

  # Based on https://github.com/NixOS/nixpkgs/issues/30904#issuecomment-445073924
  # If two ethernet ports are present but only one is plugged in, wait-online would fail
  # Any allows for wait-online service to be running as soon as one LAN interface is configured
  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
    "" # clear old command
    "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  # TODO: Investigate routing table
  systemd.network.networks."10-physical" = {
    linkConfig.RequiredForOnline = true;
    #dhcpConfig.RouteTable = 2468;
    dhcpConfig.UseDNS = true;
    matchConfig.Name = "en* eth* wl*";
    networkConfig.DHCP = "yes";
  };

  systemd.network.networks."20-wired" = {
    dhcpConfig.RouteMetric = "10";
    matchConfig.Name = "en* eth*";
  };

  systemd.network.networks."25-wireless" = {
    dhcpConfig.RouteMetric = "20";
    matchConfig.Name = "wl*";
  };

  systemd.network.networks."30-virtualisation" = {
    matchConfig.Name = "virbr* veth* vboxnet* docker* br-* hassio";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };

  # There's currently a bug where networkd breaks the ip of the lo interface (127.0.0.1)
  # Preventing some bindings to happens.
  # Seems to be fixed in next release
  systemd.network.networks."40-localhost" = {
    matchConfig.Name = "lo ";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
