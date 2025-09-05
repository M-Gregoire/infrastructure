{ pkgs, config, user, ... }:

{
  # Steam
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  users.users.${user}.packages = with pkgs; [ steam steam-run ];
}
