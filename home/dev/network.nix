{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # OpenSSL
    openssl
    # Wireless tools like iwgetid
    wirelesstools
    # TUI Wifi scanner
    wavemon
  ];

}
