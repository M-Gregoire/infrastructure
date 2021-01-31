{
  network.description = "Cloud";

  Eldir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/eldir/configuration.nix
        ];
    };
}
