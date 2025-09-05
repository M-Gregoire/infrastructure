{ config, pkgs, ... }:

{

  home = {
    pointerCursor = {
      size = 40;
      package = pkgs.vimix-cursors;
      name = "Vimix-white-cursors";
    };
  };
}
