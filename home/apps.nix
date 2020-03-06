{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # Utilities
    wget
    unzip
    # Auto mount Thunar
    udisks udiskie
    # mtp mount
    jmtpfs
    # Terminal apps
    vdirsyncer
    khal
    # Scripting audio
    pamixer
    playerctl
    pulseaudio-ctl
    # Screenshots
    scrot
    # LaTeX
    #texlive.combined.scheme-basic
    texlive.combined.scheme-full
    # Used by noCTRLqFirefox script
    xvkbd
    xdotool
    # Fuzzy finder
    fzf
    # Needed for Trash in Thunar
    # See https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    gvfs
    # Archive manager for thunar-archive-plugin
    gnome3.file-roller
    # Wireless tools like iwgetid
    wirelesstools
    # Hide pointer when not in use
    xbanish
    # Bootable iso
    wimlib
    woeusb
    # xdo
    # Hide polybar script
    xdo
    # fuser, killall and pstree
    # Needed by polybar theme
    psmisc
    # Create QRCode
    qrencode
    # Mount remote filesystems over SSH
    sshfs
    # Run appImage
    appimage-run
    # Subtitles downloader
    python37Packages.subliminal
  ];

  xdg.configFile."khal/config".source = builtins.toPath "${config.resources.pcs.paths.privateDotfiles}/khal/config";
  xdg.configFile."vdirsyncer/config".source = builtins.toPath "${config.resources.pcs.paths.privateDotfiles}/vdirsyncer/config";

  home.file.".task".source = builtins.toPath "${config.resources.pcs.paths.secrets}/task";
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-16";
    config = {
      taskd = {
        certificate = "${config.resources.services.taskd.certificate}";
        key = "${config.resources.services.taskd.key}";
        ca = "${config.resources.services.taskd.ca}";
        server = "${config.resources.services.taskd.server}:${config.resources.services.taskd.port}";
        credentials = "${config.resources.services.taskd.credentials}";
      };
      # L is lower than nothing
      uda.priority.values="H,M,,L";
      # Age doesn't change urgency
      urgency.age.coefficient="0";
    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
