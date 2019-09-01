{ pkgs, config, substituteAll,... }:

{
  imports = [
    ./dev/LSP.nix
    ./dev/compton.nix
    ./dev/encryption.nix
    ./dev/git.nix
    ./dev/go.nix
    ./dev/kdeconnect.nix
    ./dev/nix.nix
    ./dev/python.nix
    ./dev/saas.nix
    ./dev/sec.nix
    ./dev/ssh.nix
    ./dev/sys.nix
    ./dev/teensy.nix
    ./dev/term.nix
    ./dev/web.nix
  ];

  home.file.".editorconfig".source = ../dotfiles/root.editorconfig;

  home.packages = with pkgs; [
    gnumake
    gcc
    telnet
    arduino
    # Disk health
    smartmontools
    # OCR
    gocr
    # Common file association (`mimeapps.list`)
    shared-mime-info
    # DNS utils (dig)
    dnsutils
  ];
}
