{ pkgs, ... }:

{
  imports = [ ./i3-polybar.nix ];

  xsession.windowManager.i3.config.keybindings = {
    "XF86MonBrightnessUp" = "exec light -A 5";
    "XF86MonBrightnessDown" = "exec light -U 5";
  };
}
