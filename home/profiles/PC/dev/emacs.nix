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

  home.file.".emacs.d/.local/etc/bookmarks".source =
    builtins.toPath "${private-config}/dotfiles/emacs.d/bookmarks";
  home.file.".doom.d/init.el".source = "${flake-root}/dotfiles/doom.d/init.el";
  home.file.".doom.d/config.el".source =
    "${flake-root}/dotfiles/doom.d/config.el";
  home.file.".doom.d/packages.el".source =
    "${flake-root}/dotfiles/doom.d/packages.el";
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
