{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ openvpn networkmanager-openvpn ];
}
