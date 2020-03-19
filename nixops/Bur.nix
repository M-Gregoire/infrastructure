{
  Bur =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "${config.resources.hosts.bur.hostname}.${config.resources.domain}";
        targetPort = config.resources.hosts.bur.ssh.port;
      };
    };
}
