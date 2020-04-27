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
    texstudio
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
    # Matrix client
    riot-desktop
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
  programs.rofi = {
    enable = true;
    font = "${config.resources.font.name} ${config.resources.font.size}";
    extraConfig = "rofi.theme: ~/.cache/wal/colors-rofi-dark";
  };

}
