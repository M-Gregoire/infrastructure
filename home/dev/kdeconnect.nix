{ pkgs, ... }:

{
  home.packages = with pkgs;[
    breeze-icons
  ];

  # Ports 1714 to 1764 need to be open (TCP/UDP)
  # This is done is the NixOS PC profile
  services.kdeconnect = {
    enable = true;
    indicator = false;
  };
}
