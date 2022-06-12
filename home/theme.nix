{ config, pkgs, ... }:

{
  imports = [ ./theme/dunst.nix ];

  home.packages = with pkgs; [
    # Themes, icons
    arc-icon-theme
    hicolor-icon-theme
    # Needed for rofi
    comfortaa
    papirus-icon-theme
    breeze-icons
    iosevka
    fantasque-sans-mono
    noto-fonts
    # Note: Fonts are installed in nixos to be accessible system-wide
    # Debug configuration of themes
    lxappearance
  ];
}
