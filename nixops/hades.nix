{
  hades-1 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.30";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-2 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.31";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-3 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.11";
      targetPort = config.resources.services.ssh.port;
    };
  };
}
