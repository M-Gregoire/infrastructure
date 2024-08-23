{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ openvpn update-systemd-resolved ];

}
