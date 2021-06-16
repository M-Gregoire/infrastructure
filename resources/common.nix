{ pkgs, lib,... }:

{
  imports = [
    ../modules
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    services.git.username = "M-Gregoire";

    console.font.name = "Lat2-Terminus16";

    font.name = "DejaVu Sans Mono Nerd Font";
    font.size = 13.0;

    bar.font.name = "DejaVu Sans Mono Nerd Font";
    bar.font.size = 13.0;

    theme = {
      name  = "tomorrow-night";
      cursors = "capitaine-cursors";
      alpha = "F7";
      alphaPercent = "97";
      base00="1d1f21"; #1d1f21
      base01="282a2e"; #282a2e
      base02="373b41"; #373b41
      base03="969896"; #969896
      base04="b4b7b4"; #b4b7b4
      base05="c5c8c6"; #c5c8c6
      base06="e0e0e0"; #e0e0e0
      base07="ffffff"; #ffffff
      base08="cc6666"; #cc6666
      base09="de935f"; #de935f
      base0A="f0c674"; #f0c674
      base0B="b5bd68"; #b5bd68
      base0C="8abeb7"; #8abeb7
      base0D="81a2be"; #81a2be
      base0E="b294bb"; #b294bb
      base0F="a3685a"; #a3685a
    };
  };
}
