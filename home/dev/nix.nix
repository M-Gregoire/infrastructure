{ pkgs, ... }:

{
  home.packages = with pkgs;[
    #nix-prefetch-git
    #nix-prefetch-github
    #yarn2nix
    #nodePackages.node2nix
    #go2nix
    nixops
    #cachix
  ];
}
