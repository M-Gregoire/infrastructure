{ ... }:

{
  imports = [
    ../modules
    ./apps.nix
    ./cursor.nix
    ./dev.nix
    ./environment.nix
    ./gui.nix
    ./i3.nix
    ./password-management.nix
    ./theme.nix
    ./services.nix
    ../vendor/infrastructure-private/resources/home/work.nix
  ];

  nixpkgs.config = import ../nixpkgs/config.nix;
  nixpkgs.overlays = import ../nixpkgs/overlays.nix;
  xdg.configFile."nixpkgs".source = ../nixpkgs;

  xsession.scriptPath = ".hm-xsession";

  programs.home-manager.enable = true;
}
