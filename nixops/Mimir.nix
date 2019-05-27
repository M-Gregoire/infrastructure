{
  Mimir =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Mimir";
        targetPort = config.resources.ssh.deploymentPort;
      };
    };
}
