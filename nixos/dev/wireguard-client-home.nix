{ config, pkgs, ... }:

{
  systemd.network.networks."31-wg1" = {
    matchConfig.Name = "wg1";
    dns = config.resources.networking.wireguard.clients.home.dns;
  };
}
