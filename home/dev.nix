{ pkgs, config, substituteAll, flake-root, ... }:

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
    ./dev/spicetify.nix
  ];

  home.file.".editorconfig".source = "${flake-root}/dotfiles/root.editorconfig";
}
