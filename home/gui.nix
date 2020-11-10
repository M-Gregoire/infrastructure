{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Browser & emails
    firefox
    chromium
    thunderbird
    # Video
    mpv
    # Torrent
    qbittorrent
    # Ebooks
    calibre
    # Editors
    libreoffice
    leafpad
    # Mumble
    mumble
    # Music
    spotify
    # Chats
    signal-desktop
    # Thunar with plugins
    (pkgs.xfce.thunar.override { thunarPlugins = [ pkgs.xfce.thunar-archive-plugin xfce.thunar-volman ]; })
    # Network share &
    # Needed for Trash in Thunar
    # See https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    # https://github.com/NixOS/nixpkgs/issues/22064
    xfce.gvfs
    samba
    fuse
    # Exo is used for thunar to select prefered application
    # Open in terminal doesn't work otherwise
    xfce.exo
    # Thumbnail
    ffmpegthumbnailer
    # D-bus thumbnailer service
    xfce.tumbler
    # Disk managment
    gparted
    # Sound control
    pavucontrol
    # PDF reader which supports forms
    evince
    # PDF notetaking
    xournal
    # Image viewer
    nomacs
    # Veracrypt
    veracrypt
    # Matrix client
    element-desktop
    # Terminal emulator
    kitty
  ];

  xdg.configFile."kitty/kitty.conf".source = builtins.toPath "${config.resources.paths.publicDotfiles}/kitty/kitty.conf";
  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source = builtins.toPath "${config.resources.paths.publicDotfiles}/firefox/user.js";
  xdg.configFile."albert/albert.conf".source = builtins.toPath "${config.resources.paths.publicDotfiles}/albert/albert.conf";
}
