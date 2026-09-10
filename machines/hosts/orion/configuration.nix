{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:
{
  imports = [
    ../../dev/linux/systemd-networkd.nix
    ./hardware-configuration.nix
    ../../dev/linux/k3s-single-server.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  system.stateVersion = "24.05";

  boot.loader.grub = {
    devices = [ "nodev" ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # Remote LUKS unlock via SSH during early boot
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
    authorizedKeys = config.resources.services.ssh.publicKeys;
  };
  boot.kernelParams = [ "ip=:::::eth0:dhcp" "console=ttyS0,115200" "nomodeset" ];
  networking.usePredictableInterfaceNames = false;

  security.sudo.wheelNeedsPassword = false;

  # wireguard-homelab: WireGuard listener + forwarded ports for slskd
  # (50300) and transmission (60264, TCP+UDP for BT/uTP)
  # (see orion-cluster/infrastructure/wireguard-homelab).
  networking.firewall.allowedUDPPorts = [ 51820 60264 ];
  networking.firewall.allowedTCPPorts = [ 50300 60264 ];

  # SSH key for k8s CronJob pulling backups from orion to NAS
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPF9PaAiCtQbZiHijDedVUmsULe1LPOYfmaQzaWEUUx5 vps-backup-cronjob"
  ];
}
