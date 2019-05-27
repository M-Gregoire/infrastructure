{
  Skuld =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Skuld";
        targetPort = config.resources.ssh.deploymentPort;
      };
    };
}
