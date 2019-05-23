{ pkgs, ... }:

let
  keepassWithPlugins = pkgs.keepass.override {
    plugins = [
      pkgs.keepass-keepassrpc
      pkgs.keepass-keeagent
    ];
  };
in
{
  home.packages = with pkgs; [
    keepassWithPlugins
    # Remove adwaita warning (In Keepass and others)
    gnome3.gnome_themes_standard
    keybase
    keybase-gui
    # Needed for keepass autotype
    mono
    # Needed by Keebase
    kbfs
  ];
}
