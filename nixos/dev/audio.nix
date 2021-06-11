{ pkgs, config,  ... }:

{
  users.users.${config.resources.username}.packages = with pkgs;[
    pulseeffects
  ];
}
