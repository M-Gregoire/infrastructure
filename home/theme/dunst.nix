{ theme, ... }:

{
  settings = {
     global = {
      frame_color     = "#${theme.base05}";
      separator_color = "#${theme.base05}";
    };
    urgency_low = {
      background      = "#${theme.base01}";
      foreground      = "#${theme.base03}";
    };
    urgency_normal = {
      background      = "#${theme.base02}";
      foreground      = "#${theme.base05}";
    };
    urgency_critical = {
      background      = "#${theme.base08}";
      foreground      = "#${theme.base06}";
    };
  };
}
