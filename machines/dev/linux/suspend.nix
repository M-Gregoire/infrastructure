{ config, pkgs, ... }:

{
  systemd.services.audio-off = {
    enable = true;
    description = "Mute audio before suspend";
    wantedBy = [ "sleep.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 1";
      RemainAfterExit = true;
      Type = "oneshot";
      User = "${config.resources.username}";
    };
  };
}
