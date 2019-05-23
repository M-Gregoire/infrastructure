{ theme, ... }:

{
  colors = {
    rows = {
      active = {
        background = "#${theme.base01}";
        backgroundAlt = "#${theme.base01}";
        foreground = "#${theme.base0D}";
        highlight = {
          background = "#${theme.base01}";
          foreground = "#${theme.base0D}";
        };
      };
      normal = {
        background = "#${theme.base01}";
        backgroundAlt = "#${theme.base01}";
        foreground = "#${theme.base05}";
        highlight = {
          background = "#${theme.base01}";
          foreground = "#${theme.base07}";
        };
      };
      urgent = {
        background = "#${theme.base01}";
        backgroundAlt = "#${theme.base01}";
        foreground = "#${theme.base08}";
        highlight = {
          background = "#${theme.base01}";
          foreground = "#${theme.base08}";
        };
      };
    };
    window = {
      background = "#${theme.base01}";
      border = "#${theme.base01}";
      separator = "#${theme.base00}";
    };
  };
}
