{ config, pkgs, ... }:

{
  imports =
    [
      ./../../dev/luks.nix
      ../../../resources/hosts/Bur
      ../../../vendor/infrastructure-private/resources/hosts/Bur
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/suspend.nix
      ../../grub.nix
      ../../networks/home
      ../../profiles/PC
      ./hardware-configuration.nix
    ];

  services.xserver.libinput = {
    # Enable tapping
    tapping = true;
  };

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.bur.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.bur.ssh.port ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "19.09";
}
