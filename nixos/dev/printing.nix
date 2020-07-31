{ pkgs, config, ... }:

{
  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint samsungUnifiedLinuxDriver hplip hplipWithPlugin ];

  # Scanning
  hardware.sane.enable = true;
  hardware.sane.dsseries.enable = true;

  environment.systemPackages = with pkgs; [ gnome3.simple-scan ];
  users.users.${config.resources.username} = {
    extraGroups = [
      "lp"
      "scanner"
    ];
  };
}
