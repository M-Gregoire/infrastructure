{ theme, withBorder ? true, overrideIndicator ? false, ... }:

{
  focused = {
    background   = "#${theme.base0D}";
    border       = if withBorder then "#${theme.base05}" else "#${theme.base0D}";
    indicator    = if builtins.isString overrideIndicator then "#${overrideIndicator}" else "${theme.base0D}";
    text         = "#${theme.base00}";
    childBorder  = "#${theme.base0D}";
  };
  unfocused = {
    background   = "#${theme.base00}";
    border       = if withBorder then "#${theme.base01}" else "#${theme.base00}";
    indicator    = if builtins.isString overrideIndicator then "#${overrideIndicator}" else "#${theme.base01}";
    text         = "#${theme.base05}";
    childBorder  = "#${theme.base01}";
  };
  focusedInactive = {
    background   = "#${theme.base01}";
    border       = if withBorder then "#${theme.base01}" else "#${theme.base01}";
    indicator    = if builtins.isString overrideIndicator then "#${overrideIndicator}" else "#${theme.base03}";
    text         = "#${theme.base05}";
    childBorder  = "#${theme.base01}";
  };
  urgent = {
    background   = "#${theme.base08}";
    border       = if withBorder then "#${theme.base08}" else "#${theme.base08}";
    indicator    = if builtins.isString overrideIndicator then "#${overrideIndicator}" else "#${theme.base08}";
    text         = "#${theme.base00}";
    childBorder  = "#${theme.base08}";
  };
  placeholder = {
    background   = "#${theme.base00}";
    border       = if withBorder then "#${theme.base00}" else "#${theme.base00}";
    indicator    = if builtins.isString overrideIndicator then "#${overrideIndicator}" else "#${theme.base00}";
    text         = "#${theme.base04}";
    childBorder  = "#${theme.base00}";
  };
  background     = "#${theme.base07}";
}
