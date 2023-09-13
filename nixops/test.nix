{
  network.description = "Test";

  hades-1 = { config, pkgs, ... }: {
    imports = [ ../nixos/hosts/hades/hades-1/configuration.nix ];
  };
}
