{
  network.description = "Servers";

  Eldir =
    { config, pkgs, ... }:
    {
      imports =
      [
        ../nixos/hosts/Eldir/configuration.nix
      ];
    };

  Rind =
    { config, pkgs, ... }:
    {
      imports =
      [
        ../nixos/hosts/Rind/configuration.nix
      ];
    };
}
