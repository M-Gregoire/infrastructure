{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cura
    slic3r
    printrun
  ];
}
