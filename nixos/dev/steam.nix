{ pkgs, config,  ... }:

{
  # Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  users.users.${config.resources.username}.packages = with pkgs;[
    steam
    steam-run
  ];
}
