{
  Eldir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Eldir";
        targetPort = config.resources.hosts.eldir.ssh.port;
      };
    };
}
