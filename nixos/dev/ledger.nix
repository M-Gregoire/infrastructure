{ pkgs, config, ... }:

{
  # Ledger (Based on https://valh.io/blog/Ledger-NixOS.html)
  #groups.plugdev = {};
  #users.extraGroups.plugdev = { };   
  #users.users.${config.resources.username} = {
  #  extraGroups = [
  #    "plugdev"
  #  ];
  #};
  hardware.ledger.enable = true;  
  # From https://github.com/va1entin/nixos-config/blob/master/ledger.nix
}
