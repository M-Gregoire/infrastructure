{ config, pkgs, ... }:

{
  # Enable ip forwarding
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # Enable proxy ARP
  boot.kernel.sysctl."net.ipv4.conf.all.proxy_arp" = 1;
  # Enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = config.resources.networking.wireguard.server.externalInterface;
  networking.nat.internalInterfaces = config.resources.networking.wireguard.server.internalInterfaces;
  #networking.firewall = {
  # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
  # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
  # extraCommands = ''
  #  iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp3s0 -j MASQUERADE
  #  '';
  #};

  networking.wireguard.interfaces = {
    wg1 = {
      ips = config.resources.networking.wireguard.server.ips;
      listenPort = config.resources.networking.wireguard.server.port;
      privateKey = config.resources.networking.wireguard.server.privateKey;
      peers = config.resources.networking.wireguard.server.peers;
    };
  };
}
