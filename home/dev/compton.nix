{ config, ... }:

{
  services.compton = {
    enable = true;
    opacityRule = ["${config.resources.theme.alphaPercent}:class_g = 'kitty'"];
  };
}
