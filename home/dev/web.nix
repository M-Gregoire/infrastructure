{ pkgs, ... }:

{
  home.packages = with pkgs;[
    gcolor3
    nodejs
    yarn
    swagger-codegen
    # REST API Client
    insomnia
  ];
}
