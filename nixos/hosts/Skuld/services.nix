{ config, pkgs, ... }:

{
  systemd.services.backup = {
    description = "Backup all servers to HDD";
    serviceConfig.User = "root";
    script = ''
      if PATH=$PATH:${pkgs.rsync}/bin:${pkgs.openssh}/bin /root/scripts/make-backup.sh; then
        echo "Backup success"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Backup" -F "message=Weekly backup seems to have gone smoothly!" -F "priority=5"
      else
        echo "Backup fail: sending notification"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Backuped failed" -F "message=An error occured while trying to backup the servers. Fix it!" -F "priority=5"
      fi
    '';
    wantedBy = [ "default.target" ];
  };

  # systemctl list-timers

  systemd.timers.backup = {
    description = "Backup every sunday";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun 14:00:00";
    };
  };
}
