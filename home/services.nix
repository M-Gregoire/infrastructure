{ pkgs, lib, config, ... }:

{
  #services.udiskie.enable = true;

  home.file.".netrc".text = ''
    default
        login ${config.resources.services.nextcloud.username}
        password ${config.resources.services.nextcloud.password}
  '';

}
