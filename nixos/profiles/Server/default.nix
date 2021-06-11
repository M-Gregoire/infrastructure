{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ../../dev/prometheus-node-exporter.nix
  ];

  environment.systemPackages = with pkgs; [
    # Terminfo for Kitty
    kitty.terminfo
    # make
    gnumake
    # git
    git
    # Utilities
    wget unzip
    # Certificate
    openssl
    # gpg
    gnupg
  ];

  home-manager.users.${config.resources.username} = {...}: {
    imports = [
      (../../../home/profiles/Server)
    ];
    # Pass to home-manager
    nixpkgs.overlays = config.nixpkgs.overlays;
    nixpkgs.config = import ../../../nixpkgs/config.nix;
    resources = config.resources;
  };
}
