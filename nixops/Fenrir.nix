{
  FenrirDocker =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "FenrirDocker";
        targetPort = config.resources.hosts.fenrirDocker.ssh.port;
      };
    };
}
