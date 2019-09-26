{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Themes, icons and cursors
    arc-theme
    arc-icon-theme
    hicolor-icon-theme
    papirus-icon-theme
    capitaine-cursors
    # Note: Fonts are installed in nixos to be accessible system-wide
    # Debug configuration of themes
    lxappearance
    # Build base16 GTK themes
    base16-builder
  ];

  imports = [
    ./theme/gtk-2.0.nix
    ./theme/gtk-3.0.nix
  ];

  gtk = {
    enable = true;
    font = {
      name = "${config.resources.font.name} ${config.resources.font.size}";
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "${config.resources.theme.cursors}";
      gtk-cursor-theme-size = 0;
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name = ${config.resources.theme.cursors}
      gtk-cursor-theme-size = 0
    '';
  };

}
