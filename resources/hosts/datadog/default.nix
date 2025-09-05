{
  pkgs,
  config,
  lib,
  private-config,
  ...
}:

{

  config.resources = {
    #luks.drive = "/dev/nvme0n1p2";
    screen = {
      dpi = "150";
      scaleFactor = "1.5";
    };
    console.font.name = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  };
}
