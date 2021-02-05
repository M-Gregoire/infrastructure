{
  network.description = "Cloud";

  eldir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/eldir/configuration.nix
        ];
    };
}
