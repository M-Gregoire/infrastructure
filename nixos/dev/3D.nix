{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cura
    slic3r
  ];

  #services.octoprint.enable = true;

  #users.users.octoprint = {
  #  extraGroups = [
  #    # Serial
  #    "dialout"
  #  ];
  #};
}
