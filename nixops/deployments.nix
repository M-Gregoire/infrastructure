{
  network.description = "Deployments";

  mimir = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/mimir/configuration.nix ];
  };


  vali = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/vali/configuration.nix ];
  };

  hades-1 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-1/configuration.nix ];
  };
  hades-2 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-2/configuration.nix ];
  };
  hades-3 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-3/configuration.nix ];
  };
  hades-4 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-4/configuration.nix ];
  };
  hades-k = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-k/configuration.nix ];
  };

  eldir = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/eldir/configuration.nix ];
  };
  apollon-1 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/apollon/apollon-1/configuration.nix ];
  };
  apollon-2 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/apollon/apollon-2/configuration.nix ];
  };
  apollon-3 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/apollon/apollon-3/configuration.nix ];
  };
}
