{ config, lib, pkgs, ... }:

{
  launchd.agents.emacs = {
    enable = true;
    config = {
      Label = "org.nixos.emacs-daemon";
      ProgramArguments = [ "${pkgs.emacs}/bin/emacs" "--daemon=main" ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      ProcessType = "Background";
      StandardOutPath = "/tmp/emacs-daemon.log";
      StandardErrorPath = "/tmp/emacs-daemon.log";
    };
  };
}
