{ ... }:

{
  gtk.gtk2.extraConfig = ''
    style "default"
    {
      engine "hcengine" {
        edge_thickness = 2
      }

      xthickness = 2
      ythickness = 2

      EelEditableLabel::cursor_aspect_ratio = 0.1
      EelEditableLabel::cursor_color    = "#81a2be"

      GtkEntry::cursor_color    = "#81a2be"
      GtkEntry::cursor_aspect_ratio = 0.1

      GtkHSV::focus-line-pattern = "\0"

      GtkRange::stepper-size = 20

      GtkTextView::cursor_aspect_ratio = 0.1
      GtkTextView::cursor_color    = "#81a2be"

      GtkTreeView::expander-size = 16

      GtkWidget::focus-line-pattern = "\4\2"
      GtkWidget::focus-line-width = 2
      GtkWidget::focus-padding = 0
      GtkWidget::interior_focus = 1
      GtkWidget::link-color = "#81a2be"
      GtkWidget::visited-link-color = "#b294bb"

      # Nautilus
      NautilusIconContainer::frame_text = 1

      # Pidgin
      GtkIMHtml::hyperlink-color = "#81a2be"
      GtkIMHtml::hyperlink-visited-color = "#b294bb"
      GtkIMHtml::hyperlink-prelight-color = "#ffffff"

      # Evolution
      GtkHTML::link_color = "#81a2be"
      GtkHTML::vlink_color = "#b294bb"
      GtkHTML::cite_color = "#ffffff"

      fg[NORMAL]      = "#b4b7b4"
      text[NORMAL]    = "#b4b7b4"
      bg[NORMAL]      = "#1d1f21"
      base[NORMAL]    = "#1d1f21"

      fg[INSENSITIVE]      = "#b4b7b4"
      bg[INSENSITIVE]      = "#282a2e"
      text[INSENSITIVE]    = "#b4b7b4"
      base[INSENSITIVE]    = "#282a2e"

      fg[PRELIGHT]    = "#1d1f21"
      text[PRELIGHT]  = "#1d1f21"
      bg[PRELIGHT]    = "#b4b7b4"
      base[PRELIGHT]  = "#b4b7b4"

      fg[ACTIVE]      = "#c5c8c6"
      text[ACTIVE]    = "#c5c8c6"
      bg[ACTIVE]      = "#373b41"
      base[ACTIVE]    = "#373b41"

      fg[SELECTED]    = "#1d1f21"
      text[SELECTED]  = "#1d1f21"
      bg[SELECTED]    = "#b4b7b4"
      base[SELECTED]  = "#ffffff"
      }

      class "GtkWidget" style "default"
    '';
  }
