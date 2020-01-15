{
  network.description = "Home network";

  Bur =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Bur/configuration.nix
        ];
    };

  Mimir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Mimir/configuration.nix
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
