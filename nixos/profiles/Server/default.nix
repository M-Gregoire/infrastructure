 { config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Terminfo for Kitty
    kitty.terminfo
    # make
    gnumake
    # git
    git
    # Utilities
    wget unzip
  ];
}
