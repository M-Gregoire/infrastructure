{ config, lib, pkgs, ... }:

let
  # Needed for pcmanfm "Open terminal here"
  termDesktopItem = pkgs.makeDesktopItem {
    name = "terminal";
    desktopName = "Kitty";
    exec = "${pkgs.kitty}/bin/kitty -d %F";
    icon = "kitty";
    comment = "Fast, feature-rich, GPU based terminal";
    genericName = "Terminal emulator";
    categories = [ "System" "TerminalEmulator" ];
    terminal = false;
  };

in {
  imports = let
    folder = ./dev/linux;
    files = builtins.attrNames (builtins.readDir folder);
    nixFiles =
      builtins.filter (name: builtins.match ".*\\.nix" name != null) files;
  in map (name: folder + "/${name}") nixFiles;

  xsession.scriptPath = ".hm-xsession";

  xresources.properties = { "Xft.dpi" = config.resources.screen.dpi; };

  home.packages = with pkgs; [
    glibc
    linuxsampler

    # Browser & emails
    firefox
    chromium
    thunderbird

    # Ebooks
    calibre

    # Editors
    libreoffice
    # Chats
    signal-desktop

    # File manager
    pcmanfm
    termDesktopItem
    xarchiver

    ## Installed applications (https://nixos.wiki/wiki/PCManFM)
    lxmenu-data
    # Sound control
    pavucontrol

    # Screen sharing
    # rustdesk

    # PDF reader which supports forms
    evince
    ## CLI
    # Screenshots
    xdg-user-dirs
    xclip
    viewnior
    maim

    # Used by noCTRLqFirefox script
    xvkbd
    xdotool
    # Hide pointer when not in use
    xbanish
    # Hide polybar script
    xdo

    # Scripting audio
    pamixer
    playerctl
    # I'm using pipewire but can still use pulseaudio commands
    pulseaudio
    pulseaudio-ctl

    # fuser, killall and pstree
    # Needed by polybar theme
    psmisc
  ];

  # Manage XDG base directories (Set XDG_ variables)
  xdg.enable = true;
}
