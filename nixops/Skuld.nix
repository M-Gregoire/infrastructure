{
  Skuld =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "Skuld";
        targetPort = config.resources.hosts.skuld.ssh.port;
      };
    };
}
