{
  Bur =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Bur";
        targetPort = config.resources.hosts.bur.ssh.port;
      };
    };
}
