{ config, lib, pkgs, flake-root, ... }:

{
  home.packages = with pkgs; [
    jira-cli-go
  ];
}
