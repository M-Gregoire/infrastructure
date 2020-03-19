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

  # TODO: Fix required for online
  # TODO: Investigate routing table
  # TODO: See wether a physical "group" makes sense
  #systemd.network.networks."10-physical" = {
  #  linkConfig.RequiredForOnline = false;
  #  dhcpConfig.Anonymize = true;
  #  dhcpConfig.RouteTable = 2468;
  #  dhcpConfig.UseDNS = false;
  #  dhcpConfig.UseHostname = false;
  #  dhcpConfig.UseNTP = false;
  #  matchConfig.Name = "en* eth* wl*";
  #  networkConfig.DHCP = "yes";
  #  networkConfig.IPv6AcceptRA = true;
  #};

  systemd.network.networks."20-wired" = {
    dhcpConfig.RouteMetric = "10";
    matchConfig.Name = "en* eth*";
    # For some reasons, when ethernet is not plugged in, this interface is not skipped for systemd-networkd-wait-online.service
    # contrary to what https://www.freedesktop.org/software/systemd/man/systemd.network.html says
    # This fixes this behavior so that the wait online service can start.
    linkConfig.RequiredForOnline = false;
    #
    # COMMON
    #
    networkConfig.DHCP = "yes";
    networkConfig.IPv6AcceptRA = true;
    dhcpConfig.Anonymize = false;
    dhcpConfig.UseDNS = true;
    dhcpConfig.UseHostname = false;
    dhcpConfig.UseNTP = false;
  };

  systemd.network.networks."25-wireless" = {
    dhcpConfig.RouteMetric = "20";
    matchConfig.Name = "wl*";
    linkConfig.RequiredForOnline = true;
    #
    # COMMON
    #
    networkConfig.DHCP = "yes";
    networkConfig.IPv6AcceptRA = true;
    dhcpConfig.Anonymize = false;
    dhcpConfig.UseDNS = true;
    dhcpConfig.UseHostname = false;
    dhcpConfig.UseNTP = false;
  };

  systemd.network.networks."30-virtualisation" = {
    matchConfig.Name = "virbr* veth* vboxnet* docker* br-* hassio";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
