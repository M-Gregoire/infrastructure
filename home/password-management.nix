{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Remove adwaita warning in some GUIs
    gnome3.gnome_themes_standard
    keybase
    keybase-gui
    # Needed by Keebase
    kbfs
    # gopass
    gopass
    gopass-jsonapi
  ];
}
