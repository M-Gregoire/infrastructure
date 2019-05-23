{ pkgs, config,  ... }:

{
  # Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  users.users.${config.resources.host.username}.packages = with pkgs;[
    steam
    steam-run
  ];
}
