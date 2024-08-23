{ config, ... }:

{
  imports = [ ./home.nix ./environment.nix ./apps.nix ./gui.nix ];

  home.activation = {
    folders = ''
      mkdir -p ${config.resources.paths.home}/src/
      mkdir -p ${config.resources.paths.home}/Screenshots/
    '';

  };
}
