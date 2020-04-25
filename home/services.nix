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
    temperature = {
      day = config.resources.services.redshift.temperature.day;
      night = config.resources.services.redshift.temperature.night;
    };
    # Make all changes instant
    extraOptions = [ "-r" ];
  };

  # Wait 15s beforer restarting redshift when killed
  # This is to allow screen dimming with xidlehook
  # for 10 sec before locking
  systemd.user.services.redshift.Service.RestartSec = lib.mkForce 15;

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

  # Automount for removable device
  services.udiskie.enable = true;
}
