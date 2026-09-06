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

  security.sudo.wheelNeedsPassword = false;

  # SSH key for k8s CronJob pulling backups from orion to NAS
  users.users.gregoire.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPF9PaAiCtQbZiHijDedVUmsULe1LPOYfmaQzaWEUUx5 vps-backup-cronjob"
  ];
}
