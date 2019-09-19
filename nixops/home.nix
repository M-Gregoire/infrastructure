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

  Skuld =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Skuld/configuration.nix
        ];
    };
}
