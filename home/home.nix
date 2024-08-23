{ pkgs, ... }:

{
  imports = [
    ../modules
    ./dev.nix
    ./services.nix

    (if pkgs.stdenv.isLinux then ./linux.nix else ./darwin.nix)
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

}
