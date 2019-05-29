{ config, pkgs, ... }:

{
  systemd.services.backup = {
    description = "Backup all servers to HDD";
    serviceConfig.User = "root";
    script = ''
      CURRENT_WEEK=$(${pkgs.coreutils}/bin/date +%V)
      TWO_WEEKS_AGO=$(echo "($(date +%V) - 2) % 52" | ${pkgs.bc}/bin/bc)
      if PATH=$PATH:${pkgs.rsync}/bin:${pkgs.openssh}/bin /root/scripts/make-backup.sh && \
        mv /root/scripts/backups/last /root/scripts/backups/week-$CURRENT_WEEK; then
        echo "Backup success"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Backup" -F "message=Weekly backup seems to have gone smoothly!" -F "priority=5"
        if [ -d '/root/scripts/backups/week-$TWO_WEEKS_AGO' ]; then
          rm -rf /root/scripts/backups/week-$TWO_WEEKS_AGO
          ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Backup week-$TWO_WEEKS_AGO deleted" -F "message=The backup from two weeks ago was deleted." -F "priority=5"
        else
          ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Backup week-$TWO_WEEKS_AGO not found" -F "message=The backup from two weeks ago couldn't be found." -F "priority=5"
        fi
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