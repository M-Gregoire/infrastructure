{ config, lib, pkgs, flake-root, ... }:

{
  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source =
    builtins.toPath "${flake-root}/dotfiles/firefox/user.js";
}
