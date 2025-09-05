{ config, pkgs, ... }:

{
  #boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

  # jq is needed by my VPN provider script
  environment.systemPackages = with pkgs; [ jq wireguard-tools ];
}
