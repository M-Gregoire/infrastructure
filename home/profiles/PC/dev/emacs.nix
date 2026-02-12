{ pkgs, config, private-config, inputs, flake-root, system, ... }:

{
  home.packages = with pkgs; [
    emacs
    # Search
    silver-searcher
    ripgrep
    fd

    # Spell check
    enchant
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science fr ]))

    # AI Agent tools
    # Claude Code ACP for agent-shell integration
    # nodePackages."@zed-industries/claude-code-acp"  # Package not available in current nixpkgs

    # Langs
    ##  Go
    go
    gopls
    #gocode
    gomodifytags
    gotests
    gore
    godef
    #go-vet
    ## Bash
    bash-language-server
    ## Yaml
    yaml-language-server
    ## Json
    nodePackages.vscode-json-languageserver
    ## Python
    # Broken in 21.11
    #python37Packages.python-language-server
    ## Javascript
    nodePackages.javascript-typescript-langserver
    ## Nix
    nixfmt-classic
  ];

  # Symlink bookmarks for instant changes without rebuild
  # Uses absolute filesystem paths from resources.paths for out-of-store symlinks
  home.file.".emacs.d/.local/etc/bookmarks".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.privateDotfiles}/emacs.d/bookmarks";
  # Symlink entire doom.d directory for instant changes without rebuild
  # Uses absolute filesystem paths from resources.paths for out-of-store symlinks
  home.file.".doom.d".source = config.lib.file.mkOutOfStoreSymlink
    "${config.resources.paths.publicDotfiles}/doom.d";
  xresources.properties = {
    # Font backend settings
    "Xft.autohint" = "0";
    "Xft.lcdfilter" = "lcddefault";
    "Xft.antialias" = "true";
    "Xft.rgba" = "rgb";
    "Xft.hinting" = "true";
    "Xft.hintstyle" = "hintsmedium";
    # Font settings in Emacs
    #"Emacs*.FontBackend"="xft,x";
    #"Emacs*.font"="${config.resources.font.name}";
  };

  programs.git.ignores = [
    "#*"
    "*#"
    "*~"
    "#*#"
    "*.elc"
    "auto-save-list"
    "tramp"
    ".#*"
    ".org-id-locations"
    "*_archive"
    "*_flymake.*"
    "*.rel"
    ".cask/"
    "dist/"
    "flycheck_*.el"
    ".projectile"
    ".dir-locals.el"
    "flymake_*"
  ];
}
