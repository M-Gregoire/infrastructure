{ config, lib, pkgs, ... }:

{
  # https://github.com/NixOS/nixpkgs/issues/26722
  # Disabled: build failure in 26.05 (plymouth-quit.service)
  # boot.plymouth.enable = true;
}
