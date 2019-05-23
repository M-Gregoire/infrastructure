{ config, ... }:

{
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  users.users.root.openssh.authorizedKeys.keys = config.resources.ssh.publicKeys;
}
