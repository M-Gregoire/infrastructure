{ pkgs, config, substituteAll,... }:

{
  imports = [
    ./dev/bluetooth.nix
    ./dev/compton.nix
    ./dev/crypto.nix
    ./dev/doom.nix
    ./dev/emacs.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/gpg.nix
    ./dev/kdeconnect.nix
    ./dev/mimeapps.nix
    ./dev/misc.nix
    ./dev/network.nix
    ./dev/nix.nix
    ./dev/python.nix
    ./dev/ssh.nix
    ./dev/sys.nix
  ];

  home.file.".editorconfig".source = builtins.toPath "${config.resources.paths.publicDotfiles}/root.editorconfig";
}
