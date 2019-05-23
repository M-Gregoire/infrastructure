{ config, pkgs, ... }:

{
# Bluetooth
  hardware.bluetooth.enable = true;
  # A2DP Sink
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.pulseaudio = {
    # Allow Bluetooth audio devices to be used with PulseAudio,
    package = pkgs.pulseaudioFull;
    # More audio codecs
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  # Applet
  environment.systemPackages = with pkgs; [ blueman ];
}
