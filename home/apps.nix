{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # Utilities
    wget
    zip
    unzip
    # Auto mount
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
    # Run appImage
    appimage-run
    # uptime -p
    procps
  ];

  xdg.configFile."khal/config".source = builtins.toPath "${config.resources.paths.privateDotfiles}/khal/config";
  xdg.configFile."vdirsyncer/config".source = builtins.toPath "${config.resources.paths.privateDotfiles}/vdirsyncer/config";
  # https://unix.stackexchange.com/a/562158
  # If encountering other sound issues, try deleting ~/.config/pulse
  home.file.".alsoftrc".source = builtins.toPath "${config.resources.paths.publicDotfiles}/.alsoftrc";

  home.file.".task".source = builtins.toPath "${config.resources.paths.secrets}/task";
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
    };
  };
}
