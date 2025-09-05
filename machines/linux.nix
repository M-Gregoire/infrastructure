{ config, lib, pkgs, user, hostname, ... }:

{
  imports = [
    ./dev/linux/services.nix
    ./dev/linux/docker.nix
    ./dev/linux/nfs.nix
    ./dev/linux/openvpn-client.nix
  ];
  # Boot with last kernel by default
  # https://github.com/NixOS/nixpkgs/issues/30335
  # Check by comparing
  # file -L /run/current-system/kernel
  # uname -r
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    # Disk management
    parted
    # List hardware
    lshw
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
    supportedLocales = [ "all" ];
  };

  networking.hostName = hostname;

  networking.firewall.allowedTCPPorts = [ config.resources.services.ssh.port ]
    ++ config.resources.networking.firewall.openTCPPorts;
  networking.firewall.allowedUDPPorts =
    config.resources.networking.firewall.openUDPPorts;
  networking.firewall.allowedTCPPortRanges =
    config.resources.networking.firewall.openTCPPortsRange;
  networking.firewall.allowedUDPPortRanges =
    config.resources.networking.firewall.openUDPPortsRange;

  services.openssh.ports = [ config.resources.services.ssh.port ];

  networking.hosts = {
    "127.0.0.1" = [
      "${hostname}"
      "${config.resources.hostname}.${config.resources.networking.domain}"
    ];
    "::1" =
      [ "${hostname}" "${hostname}.${config.resources.networking.domain}" ];
  };

  console = {
    font = config.resources.console.font.name;
    useXkbConfig = true;
  };

  services.xserver = {
    # Compose key list available at http://duncanlock.net/blog/2013/05/03/how-to-set-your-compose-key-on-xfce-xubuntu-lxde-linux/
    xkb = {
      layout = config.resources.keyboard.layout;
      options = config.resources.keyboard.xkbOptions;
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    uid = 1000;
    group = "${user}";
    extraGroups = [ "users" "wheel" "docker" "qemu-libvirtd" "libvirtd" ];
  };
}
