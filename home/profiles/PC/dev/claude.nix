{ pkgs, config, private-config, inputs, flake-root, system, configName, ... }:

{

  homebrew.casks = [ "claude-code" ];

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
      if [ -f "$HOME/.claude/settings.local.json" ] && [ ! -L "$HOME/.claude/settings.local.json" ]; then
        $DRY_RUN_CMD rm -f "$HOME/.claude/settings.local.json"
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

  # Symlink hostname-specific settings.local.json for instant changes without rebuild
  # Uses configName from hosts.json to determine which settings to use
  home.file.".claude/settings.local.json".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.claudeConfig}/settings/${configName}/settings.local.json";
}
