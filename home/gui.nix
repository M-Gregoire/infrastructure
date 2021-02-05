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
    # File manager
    pcmanfm
    # TODO: Check if needed
    # Network share &
    # Needed for Trash in Thunar
    # See https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    # https://github.com/NixOS/nixpkgs/issues/22064
    # xfce.gvfs
    # samba
    # fuse
    # Thumbnail
    # ffmpegthumbnailer
    # Sound control
    pavucontrol
    # PDF reader which supports forms
    evince
    # Image viewer
    nomacs
    # Matrix client
    element-desktop
    # Terminal emulator
    kitty
    # Ledger
    ledger-live-desktop
  ];

  xdg.configFile."kitty/kitty.conf".source = builtins.toPath "${config.resources.paths.publicDotfiles}/kitty/kitty.conf";
  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source = builtins.toPath "${config.resources.paths.publicDotfiles}/firefox/user.js";
}
