{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # Arduino
    arduino
    esptool
    # Flash Ergodox
    # teensy_loader_cli -mmcu=atmega32u4 -w ergodox_ez_.hex
    teensy-loader-cli
    # Disk health
    smartmontools
  ];
}
