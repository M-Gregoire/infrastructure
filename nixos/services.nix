{ config, ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
}
