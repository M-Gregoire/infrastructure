{
  network.description = "Home network";

  mimir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/mimir/configuration.nix
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

  vali =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/vali/configuration.nix
        ];
    };
}
