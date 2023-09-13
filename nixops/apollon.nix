{
  apollon-1 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "${config.resources.networking.ip}";
      targetPort = config.resources.services.ssh.port;
    };
  };
  apollon-2 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "${config.resources.networking.ip}";
      targetPort = config.resources.services.ssh.port;
    };
  };
  apollon-3 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "${config.resources.networking.ip}";
      targetPort = config.resources.services.ssh.port;
    };
  };
}
