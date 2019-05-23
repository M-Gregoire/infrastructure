{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    emacs
    # ag search (Projectile)
    ag
    # Elpy dependencies
      # Rope
      python27Packages.rope
      python36Packages.rope
      # Jedi
      python27Packages.jedi
      python36Packages.jedi
      # Flake8
      python27Packages.flake8
      python36Packages.flake8
      # Autopep8
      python27Packages.autopep8
      python36Packages.autopep8
      # Yapf
      python27Packages.yapf
      python36Packages.yapf
  ];

  home.file.".emacs.d/init.el".source = ../dotfiles/emacs.d/init.el;
  home.file.".emacs.d/etc".source = ../dotfiles/emacs.d/etc;
  home.file.".emacs.d/snippets".source = ../dotfiles/emacs.d/snippets;

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
