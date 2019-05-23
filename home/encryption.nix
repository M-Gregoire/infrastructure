{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Implementation of PGP
    gnupg
    # Manage smartcard on USB
    ccid
    # Open source smart card tools
    opensc
    # Test a PC/SC driver, card or reader
    pcsctools
  ];
}
