{ pkgs, config, substituteAll, flake-root, network, ... }:

{
  imports = [
    ./dev/emacs.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/keyboard.nix
    ./dev/python.nix
    ./dev/ssh.nix
    ./dev/worktree.nix
  ];

  home.file.".editorconfig".source = "${flake-root}/dotfiles/root.editorconfig";
}
