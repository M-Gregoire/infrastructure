{ config, ... }:

{
  # BIOS
  # General settings
  boot.loader.timeout = 2;
  # GRUB
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
}
