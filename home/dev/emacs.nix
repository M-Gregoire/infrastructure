{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    emacs
    # Search
    ag
    ripgrep
    # Elpy dependencies
    #  # Rope
    #  python27Packages.rope
    #  python36Packages.rope
    #  # Jedi
    #  python27Packages.jedi
    #  python36Packages.jedi
    #  # Flake8
    #  python27Packages.flake8
    #  python36Packages.flake8
    # Autopep8
    #  python27Packages.autopep8
    #  python36Packages.autopep8
    # Yapf
    #  python27Packages.yapf
    #  python36Packages.yapf

    #  Go
    go-langserver
    # C / C++
    ccls
    # Bash
    #nodePackages.bash-language-server
    # Python
    #python27Packages.python-language-server
    python37Packages.python-language-server
    # Javascript
    nodePackages.javascript-typescript-langserver
    # Nix
    #hnix-lsp

  ];

  #home.file.".emacs.d/".source = builtins.toPath "${config.resources.paths.publicConfig}/vendor/doom-emacs/";
  #home.file.".emacs.d/init.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/init.el";
  #home.file.".emacs.d/etc".source =  builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/etc";
  #home.file.".emacs.d/snippets".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/snippets";
  #home.file.".local/share/applications/emacs-client.desktop".source = builtins.toPath "${config.resources.paths.publicDotfiles}/emacs.d/emacs-client.desktop";

  home.file.".emacs.d/.local/etc/bookmarks".source = builtins.toPath "${config.resources.paths.privateDotfiles}/emacs/bookmarks";
  home.file.".doom.d/init.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/init.el";
  home.file.".doom.d/config.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/config.el";
  home.file.".doom.d/packages.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/packages.el";

  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.emacs}/bin/emacs --daemon=main";
      ExecStop = "${pkgs.emacs}/bin/emacsclient --eval \"(kill-emacs)\"";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xresources.properties = {
    # Font backend settings
    "Xft.autohint"="0";
    "Xft.lcdfilter"="lcddefault";
    "Xft.antialias"="true";
    "Xft.rgba"="rgb";
    "Xft.hinting"="true";
    "Xft.hintstyle"="hintsmedium";
    # Font settings in Emacs
    #"Emacs*.FontBackend"="xft,x";
    #"Emacs*.font"="${config.resources.font.name}";
  };

  programs.git.ignores = [
    "#*"
    "*#"
    "*~"
    "\#*\#"
    "*.elc"
    "auto-save-list"
    "tramp"
    ".\#*"
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
