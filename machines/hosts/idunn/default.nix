{ config, lib, pkgs, inputs, ... }:

{
  homebrew.brews = [ "openssh" "openvpn" "docker" ];
  homebrew.casks = [
    "openvpn-connect"
    "firefox"
    "thunderbird"
    "signal"
    "bitwarden"
    "calibre"
    "libreoffice"
  ];

  system.stateVersion = 4;
}
