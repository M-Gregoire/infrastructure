{ config, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    #enableExtensionPack = true;
    addNetworkInterface = true;
  };
  users.extraUsers."${config.resources.username}".extraGroups = ["vboxusers"];
}
