{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Folders env
    HOME = "${config.resources.paths.home}";
    CONFIGROOT = "${config.resources.paths.publicConfig}";
    PRIVATEROOT = "${config.resources.paths.privateConfig}";
    # Go
    GOROOT = "${pkgs.go.out}/share/go";
    # Config
    BROWSER = "${config.resources.pcs.browser}";
    EDITOR = "emacsclient -nw";
    ALTERNATE_EDITOR = "nano";
    VISUAL = "${config.home.sessionVariables.EDITOR}";
    TERM = "${config.resources.pcs.terminal}";
    # Transparency percentage to use
    TRANSPARENCY = "${config.resources.theme.alphaPercent}";
    # Used by i3 sensible-terminal https://build.i3wm.org/docs/i3-sensible-terminal.htmlhttps://build.i3wm.org/docs/i3-sensible-terminal.html
    TERMINAL = "${config.home.sessionVariables.TERM}";
    # Needed for Trash in Thunar
    # https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
    # Base 16 themes
    THEME = "${config.resources.theme.name}";
    # Work wifi
    WORKWIFI = "${config.resources.networking.wifi.workSSID}";
    # Recover font and font size for Emacs
    EMACS_FONT = "${config.resources.font.name}";
    EMACS_FONT_SIZE = "${lib.strings.floatToString config.resources.font.size}";
    # Avoid Firefox profile change
    # https://github.com/NixOS/nixpkgs/issues/58923
    MOZ_LEGACY_PROFILES = "1";
    # Use gpg-agent for ssh
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    # Expose GPS coordinate in env for xidlehook script
    LATITUDE = "${builtins.toString config.resources.geo.latitude}";
    LONGITUDE = "${builtins.toString config.resources.geo.longitude}";
    # Redshift temperature
    REDSHIFT_TEMP_DAY =
      "${builtins.toString config.resources.services.redshift.temperature.day}";
    REDSHIFT_TEMP_NIGHT =
      "${builtins.toString config.resources.services.redshift.temperature.day}";
  };
}
