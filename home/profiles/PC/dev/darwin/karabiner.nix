{ config, pkgs, ... }:

let
  terminalApps = [
    "com.apple.Terminal"
    "com.googlecode.iterm2"
    "org.alacritty"
    "io.alacritty"
    "net.kovidgoyal.kitty"
  ];

  browserApps = [
    "com.apple.Safari"
    "com.google.Chrome"
    "org.mozilla.firefox"
    "com.microsoft.edgemac"
    "com.operasoftware.Opera"
    "com.brave.Browser"
    "org.chromium.Chromium"
    "com.vivaldi.Vivaldi"
  ];

  # Generate rules for swapping only c, v, x between Cmd and Ctrl globally (except terminals)
  generateGlobalCopyPasteSwaps = let
    keys = [ "c" "v" "x" ];
    # Cmd+key -> Ctrl+key globally (except terminals)
  in (map (key: {
    description = "Cmd+${key} to Ctrl+${key} globally (except terminals)";
    type = "basic";
    from = {
      key_code = key;
      modifiers = { mandatory = [ "command" ]; };
    };
    to = [{
      key_code = key;
      modifiers = [ "control" ];
    }];
    conditions = [{
      type = "frontmost_application_unless";
      bundle_identifiers = terminalApps;
    }];
  }) keys) ++
  # Ctrl+key -> Cmd+key globally (except terminals)
  (map (key: {
    description = "Ctrl+${key} to Cmd+${key} globally (except terminals)";
    type = "basic";
    from = {
      key_code = key;
      modifiers = { mandatory = [ "control" ]; };
    };
    to = [{
      key_code = key;
      modifiers = [ "command" ];
    }];
    conditions = [{
      type = "frontmost_application_unless";
      bundle_identifiers = terminalApps;
    }];
  }) keys);

  # Browser swap configuration
  swapKeys = [ "w" "t" "f" "z" "a" ];
  createSwapManipulators = key: [
    # Regular key swaps
    {
      description = "Ctrl+${key} to Cmd+${key} in browsers";
      type = "basic";
      from = {
        key_code = key;
        modifiers = { mandatory = [ "control" ]; };
      };
      to = [{
        key_code = key;
        modifiers = [ "command" ];
      }];
      conditions = [{
        type = "frontmost_application_if";
        bundle_identifiers = browserApps;
      }];
    }
    {
      description = "Cmd+${key} to Ctrl+${key} in browsers";
      type = "basic";
      from = {
        key_code = key;
        modifiers = { mandatory = [ "command" ]; };
      };
      to = [{
        key_code = key;
        modifiers = [ "control" ];
      }];
      conditions = [{
        type = "frontmost_application_if";
        bundle_identifiers = browserApps;
      }];
    }
    # Shift combinations
    {
      description = "Ctrl+Shift+${key} to Cmd+Shift+${key} in browsers";
      type = "basic";
      from = {
        key_code = key;
        modifiers = { mandatory = [ "control" "shift" ]; };
      };
      to = [{
        key_code = key;
        modifiers = [ "command" "shift" ];
      }];
      conditions = [{
        type = "frontmost_application_if";
        bundle_identifiers = browserApps;
      }];
    }
    {
      description = "Cmd+Shift+${key} to Ctrl+Shift+${key} in browsers";
      type = "basic";
      from = {
        key_code = key;
        modifiers = { mandatory = [ "command" "shift" ]; };
      };
      to = [{
        key_code = key;
        modifiers = [ "control" "shift" ];
      }];
      conditions = [{
        type = "frontmost_application_if";
        bundle_identifiers = browserApps;
      }];
    }
  ];

  # Complete Karabiner configuration
  cmdCtrlKarabinerConfig = {
    title =
      "Custom - Global Cmd/Ctrl swap for copy, paste, cut (except terminals)";
    rules = [{
      description =
        "Swap Cmd+c/v/x with Ctrl+c/v/x globally except in terminals";
      manipulators = generateGlobalCopyPasteSwaps;
    }];
  };

  browserOpenTermKarabinerConfig = {
    title = "Custom - Remap Cmd+Enter for aerospace except in browsers";
    rules = [{
      description =
        "Remap Cmd+Enter to Cmd+Shift+Enter for aerospace (except browsers)";
      manipulators = [{
        description = "Cmd+Enter to Cmd+Shift+Enter outside browsers";
        type = "basic";
        from = {
          key_code = "return_or_enter";
          modifiers = { mandatory = [ "command" ]; };
        };
        to = [{
          key_code = "return_or_enter";
          modifiers = [ "command" "shift" ];
        }];
        conditions = [{
          type = "frontmost_application_unless";
          bundle_identifiers = browserApps;
        }];
      }];
    }];
  };

  browserTabSwapKarabinerConfig = {
    title = "Custom - Swap Ctrl and Cmd for specific keys in browsers";
    rules = [{
      description =
        "Swap Ctrl and Cmd for w,t keys (with shift support) in browsers only";
      manipulators = builtins.concatLists (map createSwapManipulators swapKeys);
    }];
  };

in {
  xdg.configFile."karabiner/assets/complex_modifications/global-cmd-ctrl-copy-paste-swap-except-terminals.json" =
    {
      text = builtins.toJSON cmdCtrlKarabinerConfig;
    };

  xdg.configFile."karabiner/assets/complex_modifications/aerospace-cmd-enter-remap.json" =
    {
      text = builtins.toJSON browserOpenTermKarabinerConfig;
    };

  xdg.configFile."karabiner/assets/complex_modifications/aerospace-cmd-ctrl-swap-browser-remap.json" =
    {
      text = builtins.toJSON browserTabSwapKarabinerConfig;
    };
}
