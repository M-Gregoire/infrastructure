{ config, ... }:

{
  services.picom = {
    enable = true;
    opacityRules =
      [ "${config.resources.theme.alphaPercent}:class_g = 'kitty'" ];
  };
}
