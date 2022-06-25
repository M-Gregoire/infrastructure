{ pkgs, config, ... }:

let

  emacsDesktopItem = pkgs.makeDesktopItem {
    name = "emacs-client";
    desktopName = "Emacs client";
    exec = "${pkgs.emacs}/bin/emacsclient -s /run/user/1000/emacs/main -c %F";
    terminal = "false";
    icon = "emacs";
    comment = "Edit text";
    genericName = "Text editor";
    categories = "Development;TextEditor;";
    mimeType =
      "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;";
    extraEntries = ''
      Keywords=Text;Editor;
      StartupWMClass=Emacs;
    '';
  };

in {
  home.packages = with pkgs; [
    emacs
    emacsDesktopItem
    # Search
    ag
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

  #home.file.".emacs.d/".source = builtins.toPath "${config.resources.paths.publicConfig}/vendor/doom-emacs/";
  #home.file.".emacs.d/init.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/init.el";
  #home.file.".emacs.d/etc".source =  builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/etc";
  #home.file.".emacs.d/snippets".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/snippets";
  #home.file.".local/share/applications/emacs-client.desktop".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/emacs-client.desktop";

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
