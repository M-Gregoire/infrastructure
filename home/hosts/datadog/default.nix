{ config, lib, pkgs, flake-root, ... }:

{
  home.packages = with pkgs; [
    jira-cli-go
    (writers.writePython3Bin "pi-oauth" { flakeIgnore = [ "E265" ]; }
      (builtins.readFile "${flake-root}/dotfiles/pi-oauth.py"))
  ];
}
