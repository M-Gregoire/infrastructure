{
  network.description = "Servers";

  eldir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/eldir/configuration.nix
        ];
    };

  fenrirDocker =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/fenrirDocker/configuration.nix
        ];
    };
}
