{
  eldir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "${config.resources.hosts.eldir.ip}";
        targetPort = config.resources.hosts.eldir.ssh.port;
      };
    };
}
