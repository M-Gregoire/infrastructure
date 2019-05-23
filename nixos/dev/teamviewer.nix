{ pkgs, ... }:

{
  services.teamviewer.enable = true;
  environment.systemPackages = with pkgs; [ teamviewer ];
}
