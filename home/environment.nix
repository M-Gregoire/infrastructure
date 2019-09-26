{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # Folders env
    HOME = "${config.resources.pcs.paths.home}";
    CONFIGROOT = "${config.resources.pcs.paths.publicConfig}";
    PRIVATEROOT = "${config.resources.pcs.paths.privateConfig}";
    # Go
    GOROOT = "${pkgs.go.out}/share/go";
    GOPATH = "${config.resources.pcs.paths.home}";
    # Config
    BROWSER = "${config.resources.pcs.browser}";
    EDITOR = "emacsclient -c -n";
    ALTERNATE_EDITOR = "nano";
    VISUAL = "emacsclient -c -n";
    TERM = "${config.resources.pcs.terminal}";
    # Take personal .desktop files into account for XDG
    XDG_DATA_DIRS="${config.resources.pcs.paths.home}/.local/share/applications/emacs.desktop:$XDG_DATA_DIRS";
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
    EMACS_FONT_SIZE = "${config.resources.font.size}";
    # Avoid Firefox profile change
    # https://github.com/NixOS/nixpkgs/issues/58923
    MOZ_LEGACY_PROFILES = "1";
    # Use gpg-agent for ssh
    SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  };
}
