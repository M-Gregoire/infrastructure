{ pkgs, ... }:

{
  home.packages = with pkgs;[
    nmap
    #nmap-graphical
    # MITM
    mitmproxy
  ];
}
