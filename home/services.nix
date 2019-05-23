{ pkgs, lib, config, ... }:

let

  dunstTheme = import ./theme/dunst.nix {
    theme=config.resources.theme;
  };

in

{
  services.redshift = {
    enable = true;
    latitude = "${builtins.toString config.resources.geo.latitude}";
    longitude = "${builtins.toString config.resources.geo.longitude}";
    tray = false;
  };

  # Notifications
  services.dunst = lib.recursiveUpdate{
    enable = true;
    settings = {
      global = {
        font = "${config.resources.font.name} ${config.resources.font.size}";
        allow_markup = "yes";
        format = "<b>%a:</b> %s\n%b";
        transparency = 5;
        geometry = "0x0-0-0";
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
      };
      urgency_low = {
        timeout = 2;
      };
      urgency_normal = {
        timeout = 2;
      };
      urgency_critical = {
        timeout = 0;
      };
    };
  }dunstTheme;
}
