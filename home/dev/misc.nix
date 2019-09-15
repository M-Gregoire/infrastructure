{ pkgs, ... }:

{
  home.packages = with pkgs;[
    # OCR
    gocr
    # Common file association (`mimeapps.list`)
    shared-mime-info
  ];
}
