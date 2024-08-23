{ config, lib, pkgs, ... }:

{
  # Deploy to Arm64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];
}
