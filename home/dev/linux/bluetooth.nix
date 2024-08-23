{ pkgs, lib, config, ... }:

{
  # Make bluetooth headset buttons work
  # https://nixos.wiki/wiki/Bluetooth#Using_Bluetooth_headset_buttons_to_control_media_player
  services.mpris-proxy.enable = true;
}
