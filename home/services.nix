{ pkgs, lib, config, ... }:

{
  #services.udiskie.enable = true;

  services.syncthing.enable = true;

  home.file.".netrc".text = ''
    default
        login ${config.resources.services.nextcloud.username}
        password ${config.resources.services.nextcloud.password}
  '';

  systemd.user = {
    services.nextcloud-autosync = {
      Unit = {
        Description = "Auto sync Nextcloud";
        After = "network-online.target";
      };
      Service = {
        Type = "simple";
        ExecStart =
          "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /org ${config.resources.paths.home}/org ${config.resources.services.nextcloud.url}";
        TimeoutStopSec = "180";
        KillMode = "process";
        KillSignal = "SIGINT";
      };
      Install.WantedBy = [ "multi-user.target" ];
    };
    timers.nextcloud-autosync = {
      Unit.Description =
        "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
      Timer.OnUnitActiveSec = "5min";
      Install.WantedBy = [ "multi-user.target" "timers.target" ];
    };
    startServices = true;
  };
}
