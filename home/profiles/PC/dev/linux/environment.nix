{ config, ... }:

{
  home.sessionVariables = {
    BROWSER = "${config.resources.pcs.browser}";
    
    TERM = "${config.resources.pcs.terminal}";
    # Used by i3 sensible-terminal https://build.i3wm.org/docs/i3-sensible-terminal.htmlhttps://build.i3wm.org/docs/i3-sensible-terminal.html
    TERMINAL = "${config.home.sessionVariables.TERM}";
    # Needed for Trash in Thunar
    # https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    # GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
  };
}