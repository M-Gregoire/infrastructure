{ config, pkgs, lib, ... }: {
  imports = [
    (import ../../common.nix {
      inherit config pkgs lib;
      hostname = "eldir";
      profile = "server";
      network = "cloud";
    })
    ../../dev/systemd-networkd.nix
    ./hardware-configuration.nix
    ../../dev/k3s.nix
  ];

  system.stateVersion = "20.03";

  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.loader.systemd-boot.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # SSH on initramfs.
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh.enable = true;
  boot.initrd.network.ssh.port = config.resources.networking.initrd.ssh.port;
  boot.initrd.network.ssh.hostKeys =
    [ "${config.resources.paths.secrets}/eldir/ssh_host_rsa_key" ];
  #boot.initrd.network.ssh.hostKeys = [ (builtins.readFile (builtins.toPath "${config.resources.paths.secrets}/eldir/ssh_host_rsa_key")) ];
  boot.initrd.network.ssh.authorizedKeys =
    config.resources.services.ssh.publicKeys;
  boot.kernelParams = [ "ip=:::::eth0:dhcp" ];

  security.sudo.wheelNeedsPassword = false;

  networking.usePredictableInterfaceNames = false;
  # IPv4 settings.
  networking.interfaces.eth0.ipv4.addresses = [{
    address = "${config.resources.networking.ip}";
    prefixLength = 24;
  }];
  networking.defaultGateway = "${config.resources.networking.defaultGateway}";
  networking.nameservers = config.resources.networking.nameservers;

  # IPv6 settings.
  networking.interfaces.eth0.ipv6.addresses = [{
    address = "${config.resources.networking.ipv6}";
    prefixLength = 128;
  }];
}
