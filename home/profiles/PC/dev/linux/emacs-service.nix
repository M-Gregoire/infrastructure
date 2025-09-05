{ config, lib, pkgs, ... }:

{
  systemd.user.services.emacs = {
    Unit = {
      Description = "Emacs text editor";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.emacs}/bin/emacs --daemon=main";
      ExecStop = ''${pkgs.emacs}/bin/emacsclient --eval "(kill-emacs)"'';
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
