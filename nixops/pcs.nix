{
  network.description = "PCs";

  Mimir =
    { config, pkgs, ... }:
    {
      imports =
        [
          ../nixos/hosts/mimir/configuration.nix
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
