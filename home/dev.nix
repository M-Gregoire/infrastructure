{ pkgs, config, substituteAll, flake-root, ... }:

{
  imports = [
    ./dev/emacs.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/keyboard.nix
    ./dev/python.nix
    ./dev/ssh.nix
  ];

  home.file.".editorconfig".source = "${flake-root}/dotfiles/root.editorconfig";
}
