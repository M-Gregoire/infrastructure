{ ... }:

{
  gtk.gtk3.extraCss = ''
    @define-color theme_base_color #1d1f21;
    @define-color theme_fg_color #b4b7b4;
    @define-color theme_active_color #373b41;
    @define-color theme_insensitive_color #b4b7b4;
    @define-color theme_insensitive_bg #1d1f21;

    @define-color theme_cursor_color #81a2be;

    /* fallback mode */
    @define-color os_chrome_bg_color #1d1f21;
    @define-color os_chrome_fg_color #b4b7b4;
    @define-color os_chrome_selected_bg_color #e0e0e0;
    @define-color os_chrome_selected_fg_color #373b41;

    * {
        /* Pidgin */
        -GtkIMHtml-hyperlink-color: #81a2be;
        -GtkIMHtml-hyperlink-visited-color: #b294bb;
        -GtkIMHtml-hyperlink-prelight-color: #ffffff;

        /* Evolution */
        -GtkHTML-link-color: #81a2be;
        -GtkHTML-vlink-color: #b294bb;
        -GtkHTML-cite-color: #b5bd68;

        -GtkWidget-link-color: #81a2be;
        -GtkWidget-visited-link-color: #b294bb;
    }

    @import url("resource:///org/gnome/HighContrastInverse/a11y.css");
  '';
}
