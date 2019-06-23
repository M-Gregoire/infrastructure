{ ... }:

{
  imports = [
    ../modules
    ./apps.nix
    ./dev.nix
    ./emacs.nix
    ./environment.nix
    ./gui.nix
    ./home.nix
    ./i3.nix
    ./password-management.nix
    ./theme.nix
    ./services.nix
  ];

  nixpkgs.config = import ../nixpkgs/config.nix;
  nixpkgs.overlays = import ../nixpkgs/overlays.nix;
  xdg.configFile."nixpkgs".source = ../nixpkgs;

  programs.home-manager.enable = true;
  programs.home-manager.path = "${builtins.toPath ../vendor/home-manager}";
}
