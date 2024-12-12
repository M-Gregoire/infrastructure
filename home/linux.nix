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

  imports = [
    ./dev/linux/bluetooth.nix
    ./dev/linux/cursor.nix
    ./dev/linux/emacs-service.nix
    ./dev/linux/gpg-agent.nix
    ./dev/linux/i3.nix
    ./dev/linux/mimeapps.nix
    ./dev/linux/password-management.nix
    ./dev/linux/picom.nix
    ./dev/linux/rofi.nix
    ./dev/linux/spicetify.nix
    ./dev/linux/theme.nix
  ];
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
    leafpad
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
