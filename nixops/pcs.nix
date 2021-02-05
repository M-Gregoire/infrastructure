{
  network.description = "PCs";

  mimir =
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
