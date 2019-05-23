{ config, pkgs, ... }:

{
  programs.zathura = {
    options = {
      default-bg="#${config.resources.theme.base00}";
      default-fg="#${config.resources.theme.base01}";
      statusbar-fg="#${config.resources.theme.base04}";
      statusbar-bg="#${config.resources.theme.base01}";
      inputbar-bg="#${config.resources.theme.base00}";
      inputbar-fg="#${config.resources.theme.base05}";
      notification-error-bg="#${config.resources.theme.base08}";
      notification-error-fg="#${config.resources.theme.base00}";
      notification-warning-bg="#${config.resources.theme.base08}";
      notification-warning-fg="#${config.resources.theme.base00}";
      highlight-color="#${config.resources.theme.base0A}";
      highlight-active-color="#${config.resources.theme.base0D}";
      index-active-bg="#${config.resources.theme.base0D}";
      completion-highlight-fg="#${config.resources.theme.base02}";
      completion-highlight-bg="#${config.resources.theme.base0C}";
      completion-bg="#${config.resources.theme.base02}";
      completion-fg="#${config.resources.theme.base0C}";
      notification-bg="#${config.resources.theme.base0B}";
      notification-fg="#${config.resources.theme.base00}";
      recolor-lightcolor="#${config.resources.theme.base00}";
      recolor-darkcolor="#${config.resources.theme.base06}";
    };
  };
}
