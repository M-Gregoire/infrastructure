{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cura
  ];

  services.octoprint.enable = true;
}
