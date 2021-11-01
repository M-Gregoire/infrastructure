{ pkgs, ... }:

{
  services.cbatticon = {
    enable = true;
    commandCriticalLevel =
      "notify-send -u critical -i battery-caution 'Attention la batterie est presque vide'";
    criticalLevelPercent = 5;
  };
}
