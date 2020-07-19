{ pkgs, ... }:

{
  imports = [
    ./i3-polybar.nix
  ];

  home.packages = with pkgs; [
  ];
}
