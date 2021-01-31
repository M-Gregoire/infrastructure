{
  network.description = "Servers";

  Eldir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/eldir/configuration.nix
        ];
    };

  FenrirDocker =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/fenrirDocker/configuration.nix
        ];
    };
}
