{ pkgs, ... }:

{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # PDF
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "image/vnd.djvu" = [ "org.gnome.Evince.desktop" ];

      # Text
      "application/x-shellscript" = [ "emacs-client.desktop" ];
      "text/x-java" = [ "emacs-client.desktop" ];
      "inode/x-empty" = [ "emacs-client.desktop" ];
      "text/x-tex" = [ "emacs-client.desktop" ];
      "text/x-ruby" = [ "emacs-client.desktop" ];
      "text/x-python" = [ "emacs-client.desktop" ];
      "text/x-readme" = [ "emacs-client.desktop" ];
      "application/x-ruby" = [ "emacs-client.desktop" ];
      "text/rhtml" = [ "emacs-client.desktop" ];
      "text/plain" = [ "emacs-client.desktop" ];
      "text/x-markdown" = [ "emacs-client.desktop" ];

      # Documents
      "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];

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
      "image/png" = [ "nomacs.desktop" ];
      "image/jpeg" = [ "nomacs.desktop" ];
      # bmp
      "application/octet-stream" = [ "nomacs.desktop" ];

      # Video
      "video/ogg" = [ "mpv.desktop" ];
      "video/x-msvideo" = [ "mpv.desktop" ];
      "video/quicktime" = [ "mpv.desktop" ];
      "video/webm" = [ "mpv.desktop" ];
      "video/x-flv" = [ "mpv.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "application/x-flash-video" = [ "mpv.desktop" ];

      # Audio
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/x-flac" = [ "mpv.desktop" ];
      "audio/mp4" = [ "mpv.desktop" ];
      "application/ogg" = [ "mpv.desktop" ];

      # Virt-viewer
      "application/x-virt-viewer" = [ "remote-viewer.desktop" ];
    };
  };
}
