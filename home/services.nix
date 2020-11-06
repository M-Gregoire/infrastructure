{ pkgs, lib, config, ... }:

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

  # Automount for removable device
  services.udiskie.enable = true;
}
