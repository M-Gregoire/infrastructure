{ config, lib, pkgs, ... }:

let
  thunar-with-plugins = with pkgs; with xfce; thunar.override {
    thunarPlugins = [
      thunar-archive-plugin
    ];
  };

  rofiTheme = import ./theme/rofi.nix {
    theme=config.resources.theme;
  };

in

{
  programs.feh.enable = true;

home.packages = with pkgs; with xfce4-13; [
    # Browser & emails
    firefox-bin
    chromium
    thunderbird-bin
    # Video
    mpv
    # Torrent
    qbittorrent
    # Ebook
    calibre
    # Editors
    standardnotes
    texstudio
    libreoffice
    leafpad
    # Mumble
    mumble
    mumble_overlay
    # Music
    spotify
    # Chats
    signal-desktop
    rambox
    # Thunar with archive plugin
    thunar-with-plugins
    # Volume manager
    thunar-volman
    # Thumbnail
    ffmpegthumbnailer
    # D-bus thumbnailer service
    tumbler
    # Disk managment
    gparted
    # Sound control
    pavucontrol
    # Image edition
    gimp
    # Nextcloud-client
    nextcloud-client
    # PDF reader which supports forms
    evince
    # PDF notetaking
    xournal
  ];

  home.file.".mozilla/firefox/${config.resources.firefox.profile}/user.js".source = ../dotfiles/firefox/user.js;
  xdg.configFile."albert/albert.conf".source = ../dotfiles/albert/albert.conf;

  programs.zathura = {
    enable = true;
    options = {
      "recolor"="true";
      "recolor-keephue"="true";
      "selection-clipboard"="clipboard";
    };
  };

  # Shutdown menu
  programs.rofi = lib.recursiveUpdate{
    enable = true;
    font = "${config.resources.font.name} ${config.resources.font.size}";
  }rofiTheme;

}
