{ pkgs, config, ... }:

{
  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    samsung-unified-linux-driver
    hplip
    hplipWithPlugin
  ];

  # Scanning
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

  environment.systemPackages = with pkgs; [ simple-scan ];
  users.users.${config.resources.username} = {
    extraGroups = [ "lp" "scanner" ];
  };
}
