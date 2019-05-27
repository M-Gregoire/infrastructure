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
}
