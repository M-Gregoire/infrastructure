{
  network.description = "PCs";

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


}
