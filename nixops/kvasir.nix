{
  kvasir = { config, pkgs, ... }: {
    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };
}
