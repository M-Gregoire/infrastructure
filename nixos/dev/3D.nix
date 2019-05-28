{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cura
  ];

  services.octoprint.enable = true;

  users.users.octoprint = {
    extraGroups = [
      # Serial
      "dialout"
    ];
  };
}
