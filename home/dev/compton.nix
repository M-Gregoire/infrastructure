{ config, ... }:

{
  services.picom = {
    enable = true;
    opacityRule = ["${config.resources.theme.alphaPercent}:class_g = 'kitty'"];
  };
}
