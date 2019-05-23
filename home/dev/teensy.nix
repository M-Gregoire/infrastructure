{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # Flash Ergodox
    teensy-loader-cli
  ];

}
