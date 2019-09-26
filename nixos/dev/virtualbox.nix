{ config, ... }:

{
  virtualisation.virtualbox.host.enable = true;
  users.extraUsers."${config.resources.username}".extraGroups = ["vboxusers"];
}
