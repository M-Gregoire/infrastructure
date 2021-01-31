{
  mimir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "${config.resources.hosts.mimir.hostname}.${config.resources.domain}";
        targetPort = config.resources.hosts.mimir.ssh.port;
      };
    };
}
