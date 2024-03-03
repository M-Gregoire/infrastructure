{
  network = { storage.legacy = { }; };

  network.description = "Deployments";

  vali = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/vali/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  mimir = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/mimir/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-1 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-1/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-2 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-2/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-3 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-3/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-4 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-4/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-5 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-5/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };

  hades-6 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-6/configuration.nix ];

    deployment = {
      targetHost =
        "${config.resources.hostname}.${config.resources.networking.domain}";
      targetPort = config.resources.services.ssh.port;
    };
  };
}
