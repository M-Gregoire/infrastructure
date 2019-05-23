{ pkgs, ... }:

{
  home.packages = with pkgs;[
    nmap
    #nmap-graphical
    # MITM
    mitmproxy
    # Base64 tools
    libb64
  ];
}
