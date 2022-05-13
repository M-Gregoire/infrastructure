{
  kvasir = { config, pkgs, ... }: {
    deployment = {
      targetHost =
        "${config.resources.hosts.kvasir.hostname}.${config.resources.domain}";
      targetPort = config.resources.hosts.kvasir.ssh.port;
    };
  };
}
