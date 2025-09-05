{ config, lib, pkgs, inputs, ... }:

{

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  homebrew.enable = true;
  homebrew.brews = [ "openssh" "emacs-plus" "openvpn" "docker" ];
  homebrew.casks = [
    "openvpn-connect"
    "firefox"
    "thunderbird"
    "signal"
    "bitwarden"
    # "kitty"
    "calibre"
    "libreoffice"
  ];

  # Using brew info emacs-plus
  # gives a command to alias Emacs to /Applications folder
  # https://github.com/d12frosted/homebrew-emacs-plus/pull/517#issuecomment-1280867786
  homebrew.taps = [ "d12frosted/emacs-plus" ];
}
