{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Folders env
    HOME = "${config.resources.paths.home}";
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
    # Avoid Firefox profile change
    # https://github.com/NixOS/nixpkgs/issues/58923
    MOZ_LEGACY_PROFILES = "1";
    # Use gpg-agent for ssh
    # SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
    SSH_AUTH_SOCK = "${config.resources.paths.home}/.bitwarden-ssh-agent.sock";
  };
}
