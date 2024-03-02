{
  hades-1 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.31";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-2 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.32";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-3 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.33";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-4 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.34";
      targetPort = config.resources.services.ssh.port;
    };
  };
  hades-5 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.35";
      targetPort = 22;
      # targetPort = config.resources.services.ssh.port;
    };
  };
  hades-6 = { config, pkgs, ... }: {
    deployment = {
      targetHost = "192.168.3.36";
      targetPort = 22;
      #targetPort = config.resources.services.ssh.port;
    };
  };
}
