{ pkgs, config, substituteAll,... }:

{
  imports = [
    ./dev/compton.nix
    ./dev/git.nix
    ./dev/go.nix
    ./dev/kdeconnect.nix
    ./dev/nix.nix
    ./dev/python.nix
    ./dev/saas.nix
    ./dev/sec.nix
    ./dev/sys.nix
    ./dev/teensy.nix
    ./dev/term.nix
    ./dev/web.nix
  ];

  home.packages = with pkgs; [
    gnumake
    gcc
    telnet
    arduino
    # Disk health
    smartmontools
    # OCR
    gocr
  ];
}
