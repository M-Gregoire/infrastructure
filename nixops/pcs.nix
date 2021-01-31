{
  network.description = "PCs";

  Mimir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/Mimir/configuration.nix
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
