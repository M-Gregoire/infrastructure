{ config, lib, pkgs, ... }:

let
  rofiTheme = import ./theme/rofi.nix {
    theme=config.resources.theme;
  };

in

{
  programs.feh.enable = true;

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
    texstudio
    libreoffice
    leafpad
    # Mumble
    mumble
    # Music
    spotify
    # Chats
    unstable.signal-desktop
    # Thunar with archive plugin
    xfce4-14.thunar
    # Volume manager
    xfce4-14.thunar-volman
    xfce.thunar-archive-plugin
    # Thumbnail
    ffmpegthumbnailer
    # D-bus thumbnailer service
    xfce4-14.tumbler
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
    # Vector graphics
    inkscape
    # Image viewer
    nomacs
    # Veracrypt
    veracrypt
    # VNC Viewer
    gnome3.vinagre
  ];

  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/firefox/user.js";
  xdg.configFile."albert/albert.conf".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/albert/albert.conf";

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
