{ pkgs, ... }:

{
  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint samsungUnifiedLinuxDriver hplip ];

  # Scanning
  hardware.sane.enable = true;
  environment.systemPackages = with pkgs; [ gnome3.simple-scan ];
}
