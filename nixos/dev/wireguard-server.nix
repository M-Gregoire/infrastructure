{ config, pkgs, ... }:

######################
###      WIP       ###
######################

{
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv4.conf.all.proxy_arp" = 1;

# enable NAT
  networking.nat.enable = true;
  #networking.nat.externalInterface = config.resources.wireguard.server.externalInterface;
  networking.nat.internalInterfaces = config.resources.wireguard.server.internalInterfaces;

  networking.firewall.allowedUDPPorts = [
    config.resources.wireguard.server.port
  ];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg1 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = config.resources.wireguard.server.ips;

      # The port that Wireguard listens to. Must be accessible by the client.
      listenPort = config.resources.wireguard.server.port;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKey = config.resources.wireguard.server.privateKey;

#      peers = [
        # List of allowed peers.
#        { # Feel free to give a meaning full name
          # Public key of the peer (not a file path).
#          publicKey = config.resources.wireguard.server.peers.publicKey;
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
#          allowedIPs = config.resources.wireguard.server.peers.allowedIPs;
#        }
#      ];
    };
  };
}
