{ config, ... }:

{
  networking.dhcpcd.enable = false;

  networking.nameservers = config.resources.network.dns;
  networking.useNetworkd = true;

  networking.wireless.enable = true;

  services.resolved.enable = true;

  systemd.network.enable = true;

  systemd.network.networks."20-wired" = {
    dhcpConfig.RouteMetric = "10";
    dhcpConfig.Anonymize = true;
    #dhcpConfig.RouteTable = 2468;
    dhcpConfig.UseDNS = false;
    dhcpConfig.UseHostname = false;
    dhcpConfig.UseNTP = false;
    matchConfig.Name = "en* eth*";
    linkConfig.RequiredForOnline = true;
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
    matchConfig.Name = "virbr* veth* vboxnet* docker* br-*";
    linkConfig.Unmanaged = "yes";
    linkConfig.RequiredForOnline = false;
  };
}
