{ pkgs, ... }:

{
  imports = [ ./i3-polybar.nix ./battery.nix ];

  home.packages = with pkgs; [ brightnessctl ];

  xsession.windowManager.i3.config.keybindings = {
    "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
    "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
  };
}
