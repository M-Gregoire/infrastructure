{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # OpenSSL
    openssl
    telnet
    tcpdump
  ];

}
