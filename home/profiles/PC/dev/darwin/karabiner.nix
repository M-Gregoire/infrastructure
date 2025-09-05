{ config, pkgs, ... }:

let
  # List of terminal applications - easy to modify in one place
  terminalApps = [
    "com.apple.Terminal"
    "com.googlecode.iterm2"
    "org.alacritty"
    "io.alacritty"
    "net.kovidgoyal.kitty"
  ];

  # Generate rules for swapping ONLY Cmd+number and Ctrl+number in terminal
  generateTerminalNumberSwaps = let
    numbers = [
      "1"
      "2"
      "3"
      "4"
      "5"
      "6"
      "7"
      "8"
      "9"
      "0"
      "left_arrow"
      "right_arrow"
      "up_arrow"
      "down_arrow"
      "d"
    ];
    # Cmd+number -> Ctrl+number in terminal
  in (map (num: {
    description = "Cmd+${num} to Ctrl+${num} in terminal";
    type = "basic";
    from = {
      key_code = num;
      modifiers = { mandatory = [ "command" ]; };
    };
    to = [{
      key_code = num;
      modifiers = [ "control" ];
    }];
    conditions = [{
      type = "frontmost_application_if";
      bundle_identifiers = terminalApps;
    }];
  }) numbers) ++
  # Ctrl+number -> Cmd+number in terminal
  (map (num: {
    description = "Ctrl+${num} to Cmd+${num} in terminal";
    type = "basic";
    from = {
      key_code = num;
      modifiers = { mandatory = [ "control" ]; };
    };
    to = [{
      key_code = num;
      modifiers = [ "command" ];
    }];
    conditions = [{
      type = "frontmost_application_if";
      bundle_identifiers = terminalApps;
    }];
  }) numbers);

  # Complete Karabiner configuration
  karabinerConfig = {
    title =
      "Global Cmd/Ctrl swap with Terminal number-only swaps for Aerospace";
    rules = [{
      description =
        "Swap Cmd and Ctrl globally, but only Cmd/Ctrl+numbers in terminal";
      manipulators =
        # Terminal-specific number swaps FIRST (highest priority)
        generateTerminalNumberSwaps ++ [
          # Global Cmd to Ctrl swap (excluding terminals entirely)
          {
            description = "Cmd to Ctrl globally (except terminals)";
            type = "basic";
            from = { key_code = "left_command"; };
            to = [{ key_code = "left_control"; }];
            conditions = [{
              type = "frontmost_application_unless";
              bundle_identifiers = terminalApps;
            }];
          }
          {
            description = "Right Cmd to Right Ctrl globally (except terminals)";
            type = "basic";
            from = { key_code = "right_command"; };
            to = [{ key_code = "right_control"; }];
            conditions = [{
              type = "frontmost_application_unless";
              bundle_identifiers = terminalApps;
            }];
          }
          # Global Ctrl to Cmd swap (excluding terminals entirely)
          {
            description = "Ctrl to Cmd globally (except terminals)";
            type = "basic";
            from = { key_code = "left_control"; };
            to = [{ key_code = "left_command"; }];
            conditions = [{
              type = "frontmost_application_unless";
              bundle_identifiers = terminalApps;
            }];
          }
          {
            description = "Right Ctrl to Right Cmd globally (except terminals)";
            type = "basic";
            from = { key_code = "right_control"; };
            to = [{ key_code = "right_command"; }];
            conditions = [{
              type = "frontmost_application_unless";
              bundle_identifiers = terminalApps;
            }];
          }
        ];
    }];
  };

in {
  xdg.configFile."karabiner/assets/complex_modifications/global-cmd-ctrl-swap.json" =
    {
      text = builtins.toJSON karabinerConfig;
    };
}
