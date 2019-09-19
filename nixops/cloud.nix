{
  network.description = "Cloud";

  Eldir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Eldir/configuration.nix
        ];
    };
}
