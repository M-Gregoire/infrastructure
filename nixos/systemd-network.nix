{ config, ... }:

{
  networking.dhcpcd.enable = false;

  networking.nameservers = config.resources.network.dns;
  networking.useNetworkd = true;

  networking.wireless.enable = true;

  services.resolved.enable = true;
  # https://unix.stackexchange.com/questions/304050/how-to-avoid-conflicts-between-dnsmasq-and-systemd-resolved
  services.resolved.extraConfig = ''
  DNSStubListener=false
  '';

  systemd.network.enable = true;

  systemd.network.networks."20-wired" = {
    dhcpConfig.RouteMetric = "10";
    dhcpConfig.Anonymize = true;
    #dhcpConfig.RouteTable = 2468;
    dhcpConfig.UseDNS = false;
    dhcpConfig.UseHostname = false;
    dhcpConfig.UseNTP = false;
    matchConfig.Name = "en* eth*";
    # For some reasons, when ethernet is not plugged in, this interface is not skipped for systemd-networkd-wait-online.service
    # contrary to what https://www.freedesktop.org/software/systemd/man/systemd.network.html says
    # This fixes this behavior so that the wait online service can start.
    linkConfig.RequiredForOnline = false;
    networkConfig.DHCP = "yes";
    networkConfig.IPv6AcceptRA = true;
  };

  systemd.network.networks."25-wireless" = {
    dhcpConfig.RouteMetric = "20";
    dhcpConfig.Anonymize = true;
    #dhcpConfig.RouteTable = 2468;
    dhcpConfig.UseDNS = false;
    dhcpConfig.UseHostname = false;
    dhcpConfig.UseNTP = false;
    matchConfig.Name = "wl*";
    linkConfig.RequiredForOnline = true;
    networkConfig.DHCP = "yes";
    networkConfig.IPv6AcceptRA = true;
  };

  systemd.network.networks."30-virtualisation" = {
    matchConfig.Name = "virbr* veth* vboxnet* docker* br-* hassio";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
