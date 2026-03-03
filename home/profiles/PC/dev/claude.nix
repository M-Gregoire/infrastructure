{ pkgs, config, private-config, inputs, flake-root, system, configName, ... }:

{

  # Claude Code ACP is already installed in emacs.nix via:
  # nodePackages."@zed-industries/claude-code-acp"

  # Remove old non-symlink files before creating symlinks
  home.activation.cleanupClaudeFiles =
    config.lib.dag.entryBefore [ "linkGeneration" ] ''
      if [ -f "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
        $DRY_RUN_CMD rm -f "$HOME/.claude/CLAUDE.md"
      fi
      if [ -d "$HOME/.claude/skills" ] && [ ! -L "$HOME/.claude/skills" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.claude/skills"
      fi
      if [ -d "$HOME/.claude/hooks" ] && [ ! -L "$HOME/.claude/hooks" ]; then
        $DRY_RUN_CMD rm -rf "$HOME/.claude/hooks"
      fi
      if [ -f "$HOME/.claude/settings.json" ] && [ ! -L "$HOME/.claude/settings.json" ]; then
        $DRY_RUN_CMD rm -f "$HOME/.claude/settings.json"
      fi
    '';

  # Symlink CLAUDE.md for instant changes without rebuild
  # Uses absolute filesystem paths from resources.paths for out-of-store symlinks
  home.file.".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/CLAUDE.md";

  # Symlink skills directory for instant changes without rebuild
  # Uses absolute filesystem paths from resources.paths for out-of-store symlinks
  home.file.".claude/skills".source = config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/skills";

  # Symlink hooks directory for instant changes without rebuild
  # Uses absolute filesystem paths from resources.paths for out-of-store symlinks
  home.file.".claude/hooks".source = config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/hooks";

  # Symlink claude-hook-guard config for instant changes without rebuild
  home.file.".config/claude-hook-guard/config.yaml".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/config/claude-hook-guard.yaml";

  # Symlink hostname-specific settings.json for instant changes without rebuild
  # Uses configName from hosts.json to determine which settings to use
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/settings/${configName}/settings.json";
}
