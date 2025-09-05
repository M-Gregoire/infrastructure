{ config, lib, pkgs, flake-root, ... }:

{
  home.packages = with pkgs;
    [
      # Terminal emulator
      kitty
    ];

  xdg.configFile."kitty/kitty.conf".source =
    builtins.toPath "${flake-root}/dotfiles/kitty/kitty.conf";
  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source =
    builtins.toPath "${flake-root}/dotfiles/firefox/user.js";
}
