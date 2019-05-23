{ theme, withBorder ? true, ... }:

{
  background    = "#${theme.alpha}${theme.base00}";
  separator     = "#${theme.base01}";
  statusline    = "#${theme.base04}";
  focusedWorkspace = {
    background  = "#${theme.base0D}";
    border      = if withBorder then "#${theme.base05}" else "#${theme.base0D}";
    text        = "#${theme.base00}";
   };
  activeWorkspace = {
    background  = "#${theme.base03}";
    border      = if withBorder then "#${theme.base05}" else "#${theme.base03}";
    text        = "#${theme.base00}";
  };
  inactiveWorkspace = {
    background  = "#${theme.base01}";
    border      = if withBorder then "#${theme.base03}" else "#${theme.base01}";
    text        = "#${theme.base05}";
  };
  urgentWorkspace = {
    background  = "#${theme.base08}";
    border      = if withBorder then "#${theme.base08}" else "#${theme.base08}";
    text        = "#${theme.base00}";
  };
}
