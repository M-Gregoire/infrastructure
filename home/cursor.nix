{ config, pkgs, ... }:

{
  xsession = {
    pointerCursor = {
      size = 40;
      package = pkgs.nur.repos.ambroisie.vimix-cursors;
      name = "Vimix-white-cursors";
    };
  };
}
