{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # OpenSSL
    openssl
    telnet
    # Wireless tools like iwgetid
    wirelesstools
  ];

}
