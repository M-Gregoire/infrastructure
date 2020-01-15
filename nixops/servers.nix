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

  FenrirDocker =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/FenrirDocker/configuration.nix
        ];
    };
}
