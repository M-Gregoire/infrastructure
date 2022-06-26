{ config, pkgs, ... }:

{
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # A2DP Sink
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };
  hardware.pulseaudio = {
    # Allow Bluetooth audio devices to be used with PulseAudio,
    package = pkgs.pulseaudioFull;
    # Switch to bluetooth speaker on connect
    extraConfig = "\n      load-module module-switch-on-connect\n    ";
  };
  # Applet
  services.blueman.enable = true;
}
