{ pkgs, ... }:

{
  home.packages = with pkgs; [
    monero
    monero-gui
  ];
}
