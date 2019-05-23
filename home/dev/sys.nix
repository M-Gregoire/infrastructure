{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # lsusb
    usbutils
    # lspci
    pciutils
  ];

}
