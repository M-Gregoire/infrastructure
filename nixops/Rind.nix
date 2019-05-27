{
  Rind =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Rind";
        targetPort = config.resources.ssh.deploymentPort;
      };
    };
}
