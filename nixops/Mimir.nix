{
  Mimir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Mimir";
        targetPort = config.resources.hosts.mimir.ssh.port;
      };
    };
}
