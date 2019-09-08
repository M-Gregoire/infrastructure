{ config, ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    ports = config.resources.ssh.ports;
  };
  # Firewall for custom port
  networking.firewall.allowedTCPPorts = config.resources.ssh.ports;
  users.users.root.openssh.authorizedKeys.keys = config.resources.ssh.publicKeys;

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
