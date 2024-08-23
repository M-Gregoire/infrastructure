{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/Bluetooth#No_audio_when_using_headset_in_HSP.2FHFP_mode
  hardware.enableAllFirmware = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez;
    # A2DP Sink
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  # Applet
  services.blueman.enable = true;
}
