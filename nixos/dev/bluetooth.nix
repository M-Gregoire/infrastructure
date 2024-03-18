{ config, pkgs, ... }:

{
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
