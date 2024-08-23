{ config, lib, pkgs, flake-root, ... }:

{
  home.packages = with pkgs; [
    # Video
    mpv
    # TODO: Check if needed
    # Network share &
    # Needed for Trash in Thunar
    # See https://github.com/NixOS/nixpkgs/issues/29137#issuecomment-354229533
    # https://github.com/NixOS/nixpkgs/issues/22064
    # xfce.gvfs
    # samba
    # fuse
    # Thumbnail
    # ffmpegthumbnailer
    # Image viewer
    nomacs
    # Matrix client
    element-desktop
    # Terminal emulator
    kitty
  ];

  xdg.configFile."kitty/kitty.conf".source =
    builtins.toPath "${flake-root}/dotfiles/kitty/kitty.conf";
  home.file.".mozilla/firefox/${config.resources.pcs.firefox.profile}/user.js".source =
    builtins.toPath "${flake-root}/dotfiles/firefox/user.js";
}
