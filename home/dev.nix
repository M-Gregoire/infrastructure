{ pkgs, config, substituteAll,... }:

{
  imports = [
    ./dev/LSP.nix
    ./dev/bluetooth.nix
    ./dev/c.nix
    ./dev/compton.nix
    ./dev/emacs.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/go.nix
    ./dev/gpg.nix
    ./dev/hardware.nix
    ./dev/kdeconnect.nix
    ./dev/mimeapps.nix
    ./dev/misc.nix
    ./dev/network.nix
    ./dev/nix.nix
    ./dev/python.nix
    #./dev/saas.nix
    ./dev/sec.nix
    ./dev/ssh.nix
    ./dev/sys.nix
    ./dev/web.nix
  ];

  home.file.".editorconfig".source = builtins.toPath "${config.resources.pcs.paths.publicDotfiles}/root.editorconfig";
}
