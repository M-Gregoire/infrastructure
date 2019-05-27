{
  Bur =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Bur";
        targetPort = config.resources.ssh.deploymentPort;
      };
    };
}
