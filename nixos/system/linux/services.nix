{ config, ... }:

{
  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = false; };
  };

  users.users.root.openssh.authorizedKeys.keys =
    config.resources.services.ssh.publicKeys;
}
