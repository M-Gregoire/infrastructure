{ pkgs, ... }:

{
  # teensy_loader_cli -mmcu=atmega32u4 -w ergodox_ez_.hex
  home.packages = with pkgs;[
    # Flash Ergodox
    teensy-loader-cli
  ];

}
