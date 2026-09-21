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

  # Hide their menu bar status items (same effect as cmd-dragging icon off the bar).
  home.activation.hideMenuBarIcons =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      /usr/bin/defaults write digital.twisted.noTunes "NSStatusItem Visible Item-0" -bool false
      /usr/bin/defaults write com.oliverpeate.Bluesnooze "NSStatusItem Visible Item-0" -bool false
    '';
}
