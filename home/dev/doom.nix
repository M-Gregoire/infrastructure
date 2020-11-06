{ pkgs, config, ... }:

let

  # Currently not used in favour of nix-mode
  #hnix-lsp = import (pkgs.fetchFromGitHub {
  #  owner = "domenkozar";
  #  repo = "hnix-lsp";
  #  rev = "d678f56639067f54144ae08cdf3657889348723c";
  #  sha256 = "09vasf7kkbag1d1hd2v8wf7amglwbj3xq2qqinh1pv9hb8bdcsg2";
  #});

  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
  }) {

  doomPrivateDir = ../../dotfiles/doom.d;  # Directory containing your config.el init.el
                               # and packages.el files
  };

  emacsPackagesOverlay = self: super: {
     magit = super.magit.overrideAttrs (esuper: {
       buildInputs = esuper.buildInputs ++ [ pkgs.git ];
     });
  };

in

{
  home.packages = with pkgs;[
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
    # Doom emacs
    doom-emacs
  ];

  home.file.".local/doom/bookmarks".source = builtins.toPath "${config.resources.paths.privateDotfiles}/emacs/bookmarks";
  #home.file.".local/doom/init.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/init.el";
  #home.file.".local/doom/config.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/config.el";
  #home.file.".local/doom/packages.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/packages.el";

  home.sessionVariables = {
    DOOM = "${doom-emacs}";
  };

  home.file.".emacs.d/init.el".text = ''
     (load "default.el")
 '';

 systemd.user.services.emacs = {
    Unit = {
     Description = "Emacs text editor";
   };
   Service = {
     Type = "forking";
     ExecStart = "${doom-emacs}/bin/emacs --daemon";
     ExecStop = "${doom-emacs}/bin/emacsclient --eval \"(kill-emacs)\"";
     Restart = "on-failure";
   };
   Install = {
     WantedBy = [ "default.target" ];
     after = [ "network-online.target" ];
   };
 };

# LSP
  #home.packages = with pkgs;[
    #  Go
   # go-langserver
    # C / C++
   # ccls
    # Bash
    #nodePackages.bash-language-server
    # Python
    #python27Packages.python-language-server
   # python37Packages.python-language-server
    # Javascript
   # nodePackages.javascript-typescript-langserver
    # Nix
    #hnix-lsp
  #];
}
