{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # A2DP Sink
    settings = 	{ General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  hardware.pulseaudio = {
    # Allow Bluetooth audio devices to be used with PulseAudio,
    package = pkgs.pulseaudioFull;
    # More audio codecs
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # Switch to bluetooth speaker on connect
    extraConfig = "
      load-module module-switch-on-connect
    ";
  };
  # Applet
  services.blueman.enable = true;
}
