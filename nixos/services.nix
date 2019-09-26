{ config, ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;

  systemd.services.cleanup = {
    description = "Cleanup nix store";
    serviceConfig.User = "root";
    script = ''
      nix-collect-garbage --delete-older-than 7d
    '';
  };

  # systemctl list-timers

  systemd.timers.cleanup = {
    description = "Cleanup nix store";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15m";
      OnUnitInactiveSec = "1d";
    };
  };
}
