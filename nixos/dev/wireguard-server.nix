{ config, pkgs, ... }:

{
  #boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  #boot.kernel.sysctl."net.ipv4.conf.all.proxy_arp" = 1;
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = config.resources.wireguard.server.externalInterface;
  networking.nat.internalInterfaces = config.resources.wireguard.server.internalInterfaces;
  #networking.firewall = {
   # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
   # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
  # extraCommands = ''
  #  iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp3s0 -j MASQUERADE
  #  '';
  #};

  networking.wireguard.interfaces = {
    wg1 = {
      ips = config.resources.wireguard.server.ips;

      listenPort = config.resources.wireguard.server.port;

      privateKey = config.resources.wireguard.server.privateKey;

      peers = [
        {
          publicKey = config.resources.wireguard.server.peers.lug.publicKey;
          allowedIPs = config.resources.wireguard.server.peers.lug.allowedIPs;
        }
      ];
    };
  };
}
