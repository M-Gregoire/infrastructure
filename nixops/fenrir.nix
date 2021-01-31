{
  FenrirDocker =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "${config.resources.hosts.fenrirDocker.hostname}.${config.resources.domain}";
        targetPort = config.resources.hosts.fenrirDocker.ssh.port;
      };
    };
}
