{ config, pkgs, ... }:

{
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlight
        "64" = { enabled = 0; }; # Spotlight (⌘Space)
        "65" = { enabled = 0; }; # Spotlight Finder search (⌥⌘Space)

        # Mission Control / Spaces
        "32" = { enabled = 0; }; # Mission Control
        "33" = { enabled = 0; }; # Application windows
        "34" = { enabled = 0; }; # Move left a space
        "35" = { enabled = 0; }; # Move right a space
        "79" = { enabled = 0; }; # Switch to Desktop 1
        "80" = { enabled = 0; }; # Switch to Desktop 2
        # … add more if needed
      };
    };

    "com.apple.dock" = {
      # Prevent Spaces from automatically rearranging
      "mru-spaces" = false;
    };
  };
}
