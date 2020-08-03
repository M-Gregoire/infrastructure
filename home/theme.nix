{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Themes, icons and cursors
    arc-icon-theme
    hicolor-icon-theme
    capitaine-cursors
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

  xdg.configFile."wpg/templates/dunstrc.base".force = true;
  xdg.configFile."wpg/templates/dunstrc.base".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/wpg/templates/dunstrc.base";
}
