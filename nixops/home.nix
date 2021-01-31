{
  network.description = "Home network";

  Mimir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/mimir/configuration.nix
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

  vali =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/vali/configuration.nix
        ];
    };
}
