{ config, ... }:

{
  # BIOS
  # General settings
  boot.loader.timeout = 2;
  # GRUB
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };
}
