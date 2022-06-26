{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    emacs
    # Search
    silver-searcher
    ripgrep
    fd

    # Spell check
    aspell
    aspellDicts.fr
    aspellDicts.en

    # Langs
    ##  Go
    go
    gopls
    gocode
    gomodifytags
    gotests
    gore
    godef

    ## C / C++
    ccls
    gcc # go-vet
    ## Python
    # Broken in 21.11
    #python37Packages.python-language-server
    ## Javascript
    nodePackages.javascript-typescript-langserver
    ## Nix
    nixfmt
  ];

  home.file.".emacs.d/.local/etc/bookmarks".source =
    builtins.toPath "${config.resources.paths.privateDotfiles}/emacs/bookmarks";

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.emacs}/bin/emacs --daemon=main";
      ExecStop = ''${pkgs.emacs}/bin/emacsclient --eval "(kill-emacs)"'';
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

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
