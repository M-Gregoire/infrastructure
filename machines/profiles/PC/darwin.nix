{ config, lib, pkgs, ... }:

{
  users.users.gregoire.home = "/Users/gregoire";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

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
}
