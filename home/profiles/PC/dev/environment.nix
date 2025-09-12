{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Folders env
    HOME = "${config.resources.paths.home}";
    # CONFIGROOT = "${config.resources.paths.publicConfig}";
    # PRIVATEROOT = "${config.resources.paths.privateConfig}";
    # Go
    # GOROOT = "~/go";
    PATH = "$PATH:${config.resources.paths.home}/bin";
    # Config
    EDITOR = "emacsclient -nw";
    ALTERNATE_EDITOR = "nano";
    VISUAL = "${config.home.sessionVariables.EDITOR}";
    # Transparency percentage to use
    TRANSPARENCY = "${config.resources.theme.alphaPercent}";
    # Base 16 themes
    THEME = "${config.resources.theme.name}";
    # Recover font and font size for Emacs
    EMACS_FONT = "${config.resources.font.name}";
    EMACS_FONT_SIZE = "${lib.strings.floatToString config.resources.font.size}";
    # Avoid Firefox profile change
    # https://github.com/NixOS/nixpkgs/issues/58923
    MOZ_LEGACY_PROFILES = "1";
    # Use gpg-agent for ssh
    # SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    # Expose GPS coordinate in env for xidlehook script
    LATITUDE = "${builtins.toString config.resources.geo.latitude}";
    LONGITUDE = "${builtins.toString config.resources.geo.longitude}";
  };
}
