{ pkgs, config, ... }:

{
  imports = [
    # Brother scanner
    <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
  ];

  # Printing
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint samsungUnifiedLinuxDriver hplip ];

  # Scanning
  hardware.sane.enable = true;
  environment.systemPackages = with pkgs; [ gnome3.simple-scan ];
  users.users.${config.resources.username} = {
    extraGroups = [
      "lp"
      "scanner"
    ];
  };
}
