{ config, pkgs, lib, ... }:

{
  home.file.".scripts".source = ../scripts;
  home.sessionVariables = {
      # Folders env
      HOME = "/home/${config.resources.host.username}";
      CONFIGROOT = "${config.home.sessionVariables.HOME}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}";
      PRIVATEROOT = "${config.home.sessionVariables.CONFIGROOT}/vendor/${config.resources.config.privateRepo}";
      SCRIPTS = "${config.home.sessionVariables.HOME}/.scripts";
      # Go
      GOROOT = "${pkgs.go.out}/share/go";
      GOPATH = "${config.home.sessionVariables.HOME}";
      # Config
      BROWSER = "${config.resources.browser}";
      EDITOR = "emacsclient -c -n";
      ALTERNATE_EDITOR = "nano";
      VISUAL = "emacsclient -c -n";
      TERM = "${config.resources.terminal}";
      # Transparency percentage to use
      TRANSPARENCY = "${config.resources.theme.alphaPercent}";
      # Used by i3 sensible-terminal https://build.i3wm.org/docs/i3-sensible-terminal.htmlhttps://build.i3wm.org/docs/i3-sensible-terminal.html
      TERMINAL = "${config.home.sessionVariables.TERM}";
      SSH_AUTH_SOCK = "${config.home.sessionVariables.HOME}/.KeeAgent";
      # Needed for Trash in Thunar
      # https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
      GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
      # Base 16 themes
      THEME = "${config.resources.theme.name}";
      # Work wifi
      WORKWIFI = "${config.resources.wifi.workSSID}";
      # Recover font and font size for Emacs
      EMACS_FONT = "${config.resources.font.name}";
      EMACS_FONT_SIZE = "${config.resources.font.size}";
  };
}
