{ config, pkgs, ... }:

{
  systemd.network.netdevs."30-wg0" = {
    netdevConfig.Kind = "wireguard";
    netdevConfig.Name = "wg0";
    extraConfig = ''
          [WireGuard]
          PrivateKey=${config.resources.wireguard.client.privateKey}
          [WireGuardPeer]
          PublicKey=${config.resources.wireguard.client.publicKey}
          AllowedIPs=0.0.0.0/0, ::/0
          Endpoint=${config.resources.wireguard.client.endpointIp}:${config.resources.wireguard.client.endpointPort}
          PersistentKeepalive=25
        '';
  };

  systemd.network.networks."30-wg0" = {
    matchConfig.Name = "wg0";
    address = config.resources.wireguard.client.address;
    dns = config.resources.wireguard.client.dns;
    routes = [
      {
        routeConfig.Destination = "0.0.0.0/0";
        routeConfig.Gateway = "10.10.28.217";
        routeConfig.GatewayOnlink = "true";
       }
    ];
    extraConfig = ''
          [RoutingPolicyRule]
          To=10.10.28.217
          Table=2468
        '';
  };
}
