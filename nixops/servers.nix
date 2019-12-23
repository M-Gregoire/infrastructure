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

  Skuld =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Skuld/configuration.nix
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
