{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      # Common file association (`mimeapps.list`)
      shared-mime-info
    ];

  xdg.configFile."mimeapps.list".force = true;
  # Use `file --mime-type <filename>` to get mime type
  # Check $XDG_DATA_DIRS to search for .desktop
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDF
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "image/vnd.djvu" = [ "org.gnome.Evince.desktop" ];

      # Text
      "application/x-shellscript" =
        [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-java" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "inode/x-empty" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-tex" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-ruby" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-python" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-readme" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "application/x-ruby" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/rhtml" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/plain" = [ "emacs-client.desktop" "leafpad.desktop" ];
      "text/x-markdown" = [ "emacs-client.desktop" "leafpad.desktop" ];

      # Books
      "application/epub+zip" = [ "calibre-ebook-viewer.desktop" ];

      # Documents
      "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
        [ "writer.desktop" ];

      # Web
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/ftp" = [ "firefox.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox.desktop" ];
      "application/x-extension-htm" = [ "firefox.desktop" ];
      "application/x-extension-html" = [ "firefox.desktop" ];
      "application/x-extension-shtml" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "application/x-extension-xhtml" = [ "firefox.desktop" ];
      "application/x-extension-xht" = [ "firefox.desktop" ];

      # Image
      "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
      # bmp
      "application/octet-stream" = [ "org.nomacs.ImageLounge.desktop" ];

      # Video
      "video/ogg" = [ "mpv.desktop" ];
      "video/x-msvideo" = [ "mpv.desktop" ];
      "video/quicktime" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/x-flv" = [ "mpv.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "application/x-flash-video" = [ "mpv.desktop" ];
      "video/MP2T" = [ "mpv.desktop" ];
      "image/x-tga" = [ "mpv.desktop" ];

      # Audio
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/x-flac" = [ "mpv.desktop" ];
      "audio/mp4" = [ "mpv.desktop" ];
      "application/ogg" = [ "mpv.desktop" ];
      "audio/x-mod" = [ "mpv.desktop" ];

      # Virt-viewer
      "application/x-virt-viewer" = [ "remote-viewer.desktop" ];
    };
  };
}
