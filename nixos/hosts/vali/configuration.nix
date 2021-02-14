{ config, pkgs, ... }:

{
  imports =
    [
      ../../../resources/hosts/vali
      ../../../vendor/infrastructure-private/resources/hosts/vali
      ../../../vendor/infrastructure-private/resources/networks/home/nfs-safe.nix
      ../../common.nix
      ../../dev/bluetooth.nix
      ../../dev/suspend.nix
      ../../dev/boot/grub-uefi.nix
      ../../dev/displaylink.nix
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

  services.xserver.monitorSection = ''
      DisplaySize 162 91
    '';

  networking.wireless.enable = true;

  networking.firewall.allowedTCPPorts = [ config.resources.hosts.vali.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.vali.ssh.port ];

  boot.loader.grub.efiSupport = true;

  system.stateVersion = "20.03";
}
