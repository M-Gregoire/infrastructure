{ pkgs, config, substituteAll, ... }:

{
  imports = [
    ./dev/bluetooth.nix
    ./dev/compton.nix
    ./dev/emacs.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/gpg.nix
    ./dev/keyboard.nix
    ./dev/mimeapps.nix
    ./dev/nix.nix
    ./dev/python.nix
    ./dev/ssh.nix
  ];

  home.file.".editorconfig".source = builtins.toPath
    "${config.resources.paths.publicDotfiles}/root.editorconfig";
}
