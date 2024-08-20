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
  ];

  # Manage XDG base directories (Set XDG_ variables)
  xdg.enable = true;
  xdg.configFile."nixpkgs".source = ../nixpkgs;

  xsession.scriptPath = ".hm-xsession";

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";

}
