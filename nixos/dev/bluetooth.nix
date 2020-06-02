{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # A2DP Sink
    config = 	{ General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  hardware.pulseaudio = {
    # Allow Bluetooth audio devices to be used with PulseAudio,
    package = pkgs.pulseaudioFull;
    # More audio codecs
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  # Applet
  services.blueman.enable = true;
}
