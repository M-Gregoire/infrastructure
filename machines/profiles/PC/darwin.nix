{ config, lib, pkgs, user, ... }:

let
  aerospaceTap = builtins.fetchGit {
    url = "https://github.com/nikitabobko/homebrew-tap";
    rev = "2eff00794112cf73fdefeec27cd9b30abe644408";
  };
in {
  imports = [ ./dev/darwin/shortcuts.nix ];

  users.users.${user}.home = "/Users/${user}";

  # # The platform the configuration will be used on.
  # nixpkgs.hostPlatform = "aarch64-darwin";

  nix-homebrew = { taps = { "nikitabobko/homebrew-tap" = aerospaceTap; }; };

  homebrew.enable = true;
  homebrew.brews = [ "borders" "k9s" ];
  homebrew.casks = [
    "emacs-mac"
    "hammerspoon"
    "raycast"
    "kitty"
    "notunes"
    "bluesnooze"
    "karabiner-elements"
    "nikitabobko/tap/aerospace"
  ];
  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  # Raycast set hotkey
  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      # from your plist dump:
      # plutil -convert xml1 ~/Library/Preferences/com.raycast.macos.plist -o raycast.plist
      raycastGlobalHotkey = "Command-2";
    };
  };

  system.activationScripts.pmset.text = ''
    # Never sleep when on AC power (equivalent to the GUI “Prevent sleeping on power adapter”)
    /usr/bin/pmset -c sleep 0
  '';
  system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "${user}";

}
