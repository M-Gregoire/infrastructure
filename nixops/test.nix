{
  network.description = "Test";

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
}
