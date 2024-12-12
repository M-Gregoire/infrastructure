{ config, pkgs, lib, modulesPath, inputs, ... }: {
  imports = [
    (import ../../common.nix {
      inherit config pkgs lib inputs;
      hostname = "orion";
      profile = "server";
      network = "cloud";
    })
    ../../dev/linux/systemd-networkd.nix
    ./hardware-configuration.nix
    ../../dev/linux/k3s.nix
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
}
