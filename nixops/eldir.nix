{
  eldir = { config, pkgs, ... }: {
    deployment = {
      targetHost = "${config.resources.networking.ip}";
      targetPort = config.resources.services.ssh.port;
    };
  };
}
