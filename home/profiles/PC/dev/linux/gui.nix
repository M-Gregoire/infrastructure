{
  config,
  lib,
  pkgs,
  ...
}:

{

  home.packages = with pkgs; [
    mpv
    nomacs
    element-desktop
  ];
}
