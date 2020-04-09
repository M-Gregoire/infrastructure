{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # OpenSSL
    openssl
    telnet
    tcpdump
    # Wireless tools like iwgetid
    wirelesstools
    # Wireshark
    wireshark
  ];

}
