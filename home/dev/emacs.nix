{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    #emacs
    # ag search (Projectile)
    #ag
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
  ];

  #home.file.".emacs.d/".source = builtins.toPath "${config.resources.pcs.paths.publicConfig}/vendor/doom-emacs/";

  #home.file.".emacs.d/init.el".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/emacs.d/init.el";
  #home.file.".emacs.d/etc".source =  builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/emacs.d/etc";
  #home.file.".emacs.d/snippets".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/emacs.d/snippets";
  #home.file.".emacs.d/bookmarks".source = builtins.toPath "${config.resources.pcs.paths.privateDotfiles}/emacs/bookmarks";
  #home.file.".local/share/applications/emacs-client.desktop".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/emacs.d/emacs-client.desktop";

  xresources.properties = {
    # Font backend settings
    "Xft.autohint"="0";
    "Xft.lcdfilter"="lcddefault";
    "Xft.dpi"="96";
    "Xft.antialias"="true";
    "Xft.rgba"="rgb";
    "Xft.hinting"="true";
    "Xft.hintstyle"="hintsmedium";
    # Font settings in Emacs
    "Emacs*.FontBackend"="xft,x";
    "Emacs*.font"="${config.resources.font.name}-${config.resources.font.size}";
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
