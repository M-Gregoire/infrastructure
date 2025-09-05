{ config, lib, pkgs, ... }:

{
  # Let NixOS handle keyboard management
  home.keyboard = null;
}
