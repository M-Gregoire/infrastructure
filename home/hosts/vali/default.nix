{ pkgs, ... }:

{
  imports = [
    ./i3-polybar.nix
  ];

  home.packages = with pkgs; [
    # Backlight control
    xorg.xbacklight
  ];

  xsession.windowManager.i3.config.keybindings = {
    "XF86MonBrightnessUp" = "exec xbacklight -inc 5";
    "XF86MonBrightnessDown" = "exec xbacklight -dec 5";
  };
}
