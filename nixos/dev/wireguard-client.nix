{ config, pkgs, ... }:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  environment.systemPackages = with pkgs; [ wireguard-tools ];

  systemd.network.netdevs."35-wg0" = {
    netdevConfig.Kind = "wireguard";
    netdevConfig.Name = "wg0";
    netdevConfig.MTUBytes = "1300";
    extraConfig = ''
          [WireGuard]
          PrivateKey=${config.resources.wireguard.client.privateKey}
          ListenPort=auto
          [WireGuardPeer]
          PublicKey=${config.resources.wireguard.client.publicKey}
          AllowedIPs=0.0.0.0/0, ::/0
          Endpoint=${config.resources.wireguard.client.endpointIp}:${config.resources.wireguard.client.endpointPort}
          PersistentKeepalive = 25
        '';
  };

  systemd.network.networks."35-wg0" = {
    matchConfig.Name = "wg0";
    networkConfig.Address = config.resources.wireguard.client.address;
  };
}
