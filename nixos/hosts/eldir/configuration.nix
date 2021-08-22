{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/eldir
    ../../../vendor/infrastructure-private/resources/hosts/eldir
    ../../common.nix
    ../../systemd-networkd.nix
    ../../networks/cloud
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  system.stateVersion = "20.03";

  networking.firewall.allowedTCPPorts =
    [ config.resources.hosts.eldir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.eldir.ssh.port ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.loader.systemd-boot.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # SSH on initramfs.
  boot.initrd.network.enable = true;
  boot.initrd.network.ssh.enable = true;
  boot.initrd.network.ssh.port =
    config.resources.hosts.eldir.networking.initrd.ssh.port;
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
    address = "${config.resources.hosts.eldir.ip}";
    prefixLength = 24;
  }];
  networking.defaultGateway =
    "${config.resources.hosts.eldir.networking.defaultGateway}";
  networking.nameservers = config.resources.hosts.eldir.networking.nameservers;

  # IPv6 settings.
  networking.interfaces.eth0.ipv6.addresses = [{
    address = "${config.resources.hosts.eldir.networking.ipv6}";
    prefixLength = 128;
  }];
}
