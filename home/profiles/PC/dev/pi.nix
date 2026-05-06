{ config, private-config, inputs, flake-root, configName, ... }:

{
  # Remove old non-symlink files before creating symlinks
  home.activation.cleanupPiFiles =
    config.lib.dag.entryBefore [ "linkGeneration" ] ''
      if [ -f "$HOME/.pi/agent/settings.json" ] && [ ! -L "$HOME/.pi/agent/settings.json" ]; then
        $DRY_RUN_CMD rm -f "$HOME/.pi/agent/settings.json"
      fi
      if [ -d "$HOME/.pi/agent/skills" ] && [ ! -L "$HOME/.pi/agent/skills" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.pi/agent/skills"
      fi
      if [ -d "$HOME/.pi/agent/extensions" ] && [ ! -L "$HOME/.pi/agent/extensions" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.pi/agent/extensions"
      fi
    '';

  # Symlink hostname-specific settings.json for instant changes without rebuild
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.piConfig}/settings/${configName}/settings.json";

  # Symlink skills directory for instant changes without rebuild
  home.file.".pi/agent/skills".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.piConfig}/skills";

  # Symlink extensions directory for instant changes without rebuild
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.piConfig}/extensions";
}
