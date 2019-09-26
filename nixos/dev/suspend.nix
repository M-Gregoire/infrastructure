{ config, pkgs, ... }:

{
  systemd.services.audio-off = {
    enable = true;
    description = "Mute audio before suspend";
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.pamixer}/bin/pamixer --mute";
      RemainAfterExit = true;
      Type = "oneshot";
      User = "${config.resources.username}";
    };
  };
}
