{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.sketchybar
  ];

  home.file.".config/sketchybar/sketchybarrc".source = ./sketchybar/sketchybarrc;
  home.file.".config/sketchybar/plugins".source = ./sketchybar/plugins;
  home.file.".config/sketchybar/plugins".recursive = true;
}
