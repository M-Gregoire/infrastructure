{
  network.description = "Home network";

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

  vali =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/vali/configuration.nix
        ];
    };
}
