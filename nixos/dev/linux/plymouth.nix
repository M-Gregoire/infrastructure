{ config, lib, pkgs, ... }:

{
  # https://github.com/NixOS/nixpkgs/issues/26722
  boot.plymouth.enable = true;
}
