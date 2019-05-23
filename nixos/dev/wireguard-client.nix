{ config, pkgs, ... }:

{
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      allowedIPsAsRoutes = false;
      postSetup = ''
        ${pkgs.iproute}/bin/ip route add $(${pkgs.iproute}/bin/ip route get "$(${pkgs.wireguard}/bin/wg show wg0 endpoints | sed -n 's/.*\t\(.*\):.*/\1/p')" | sed '/ via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/{s/^\(.* via [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/}' | head -n 1) 2>/dev/null || true
        ${pkgs.iproute}/bin/ip route add default via ${config.resources.wireguard.client.ip} dev wg0
      '';
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = config.resources.wireguard.client.ips;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKey = "${config.resources.wireguard.client.privateKey}";

      peers = [
        # For a client configuration, one peer entry for the server will suffice.
        {
          # Public key of the server (not a file path).
          publicKey = "${config.resources.wireguard.client.publicKey}";

          # Forward all the traffic via VPN.
          allowedIPs = [ "0.0.0.0/0" "::/0" ];

          # Set this to the server IP and port.
          endpoint = "${config.resources.wireguard.client.endpoint}";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/59603
  #systemd.services.wireguard-wg0.after = [ "NetworkManager-wait-online.service" ];
  #systemd.services.wireguard-wg0.requires = [ "NetworkManager-wait-online.service" ];
}
