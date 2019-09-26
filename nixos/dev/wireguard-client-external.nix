{ config, pkgs, ... }:

{
  systemd.network.netdevs."30-wg0" = {
    netdevConfig.Kind = "wireguard";
    netdevConfig.Name = "wg0";
    extraConfig = ''
          [WireGuard]
          PrivateKey=${config.resources.networking.wireguard.clients.external.privateKey}
          [WireGuardPeer]
          PublicKey=${config.resources.networking.wireguard.clients.external.publicKey}
          AllowedIPs=0.0.0.0/0, ::/0
          Endpoint=${config.resources.networking.wireguard.clients.external.endpointIp}:${config.resources.networking.wireguard.clients.external.endpointPort}
          PersistentKeepalive=25
        '';
  };

  systemd.network.networks."30-wg0" = {
    matchConfig.Name = "wg0";
    address = config.resources.networking.wireguard.clients.external.address;
    dns = config.resources.networking.wireguard.clients.external.dns;
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
