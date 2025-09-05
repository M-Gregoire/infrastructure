{ config, lib, pkgs, ... }:

{
  launchd.agents.notunes = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "NoTunes" ];
      RunAtLoad = true;
      KeepAlive = { SuccessfulExit = false; };
    };
  };

  launchd.agents.bluesnooze = {
    enable = true;
    config = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Bluesnooze" ];
      RunAtLoad = true;
      KeepAlive = { SuccessfulExit = false; };
    };
  };
}
