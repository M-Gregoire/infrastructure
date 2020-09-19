{ pkgs, config, ... }:

let
 doom-emacs = pkgs.callPackage (builtins.fetchTarball {
   url = https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz;
 }) {
   doomPrivateDir = ../../dotfiles/doom.d;  # Directory containing your config.el init.el
                               # and packages.el files
 };
in {
 home.file.".local/doom/bookmarks".source = builtins.toPath "${config.resources.paths.privateDotfiles}/emacs/bookmarks";
 #home.file.".local/doom/init.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/init.el";
 #home.file.".local/doom/config.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/config.el";
 #home.file.".local/doom/packages.el".source = builtins.toPath "${config.resources.paths.publicDotfiles}/doom.d/packages.el";

 home.packages = [ doom-emacs ];
 home.file.".emacs.d/init.el".text = ''
     (load "default.el")
 '';
}
