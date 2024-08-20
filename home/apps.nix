{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # Utilities
    wget
    zip
    unzip
    # mtp mount
    jmtpfs
    # Scripting audio
    pamixer
    playerctl
    # I'm using pipewire but can still use pulseaudio commands
    pulseaudio
    pulseaudio-ctl
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
    # fuser, killall and pstree
    # Needed by polybar theme
    psmisc
    # Mount remote filesystems over SSH
    sshfs
    # uptime -p
    procps
  ];
}
