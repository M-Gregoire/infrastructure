{ config, pkgs, flake-root, ... }:

{
  xdg.configFile."wpg/templates/dunstrc.base".source = pkgs.substituteAll {
    src = "${flake-root}/dotfiles/dunst/dunstrc.base";
    user = "${config.resources.username}";
  };

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
