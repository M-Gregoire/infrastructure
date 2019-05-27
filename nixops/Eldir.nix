{
  Eldir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Eldir";
        targetPort = config.resources.ssh.deploymentPort;
      };
    };
}
