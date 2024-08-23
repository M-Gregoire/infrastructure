{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Remove adwaita warning in some GUIs
    gnome.gnome-themes-extra
    keybase
    keybase-gui
    # Needed by Keebase
    kbfs
  ];

}
