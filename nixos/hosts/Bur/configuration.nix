{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/Bur
      ../../../vendor/infrastructure-private/resources/hosts/Bur
      ../../../vendor/infrastructure-private/resources/networks/home/nfs-safe.nix
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/boot/grub-uefi.nix
      ../../dev/suspend.nix
      ../../networks/home
      ../../profiles/PC
      ./../../dev/luks.nix
      ./hardware-configuration.nix
    ];

  services.xserver.libinput = {
    # Enable tapping
    enable = true;
    tapping = true;
    accelProfile = "adaptive";
    accelSpeed = "2";
  };

  networking.wireless.enable = true;

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.bur.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.bur.ssh.port ];

  boot.loader.grub.efiSupport = true;

  system.stateVersion = "20.03";
}
