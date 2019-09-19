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
}
