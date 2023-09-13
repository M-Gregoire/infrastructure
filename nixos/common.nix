{ config, pkgs, lib, hostname, cluster ? "", clusterRole ? "", profile, network
, ... }:

# Note: It appears impossible to create the import paths
# based on the define hostname through options (https://www.reddit.com/r/NixOS/comments/q2t69g/comment/hfrd1ig)
#

{
  imports = lib.flatten [
    ../modules
    ./dev/docker.nix
    ./dev/nfs.nix
    (if cluster == "" then
      ../. + "/resources/hosts/${hostname}"
    else [
      (import (../. + "/resources/hosts/${cluster}") {
        inherit config pkgs lib clusterRole;
      })
      (import
        (../. + "/vendor/infrastructure-private/resources/hosts/${cluster}") {
          inherit config pkgs lib clusterRole;
        })
      (import (./. + "/hosts/${cluster}") {
        inherit config pkgs lib clusterRole;
      })
      (../. + "/resources/hosts/${cluster}/${hostname}")
    ])
    ../resources/common.nix
    (./. + "/profiles/${profile}")
    (./. + "/networks/${network}")
    ./dev/openvpn-client.nix
    ./dev/term.nix
    ./services.nix
  ];

  config = {

    # Boot with last kernel by default
    # https://github.com/NixOS/nixpkgs/issues/30335
    # Check by comparing
    # file -L /run/current-system/kernel
    # uname -r
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    environment.systemPackages = with pkgs; [
      # File type
      file
      # Disk management
      parted
      # DNS utils (dig)
      dnsutils
      # htop
      htop
      # List hardware
      lshw
      # tmux
      tmux
      # tree
      tree
      # dhclient
      dhcp
      # lsof
      lsof
    ];

    nixpkgs.config = import ../nixpkgs/config.nix;
    nixpkgs.overlays = import ../nixpkgs/overlays.nix;

    networking.hostName = config.resources.hostname;

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
        "${config.resources.hostname}"
        "${config.resources.hostname}.${config.resources.networking.domain}"
      ];
      "::1" = [
        "${config.resources.hostname}"
        "${config.resources.hostname}.${config.resources.networking.domain}"
      ];
    };

    users.groups.${config.resources.username} = {
      name = "${config.resources.username}";
      members = [ "${config.resources.username}" ];
      gid = 1000;
    };

    users.users.${config.resources.username} = {
      isNormalUser = true;
      home = "/home/${config.resources.username}";
      uid = 1000;
      group = "${config.resources.username}";
      extraGroups = [ "users" "wheel" "docker" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
    };

    console = {
      font = config.resources.console.font.name;
      useXkbConfig = true;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_MESSAGES = "en_US.UTF-8";
        LC_TIME = "fr_FR.UTF-8";
      };
      supportedLocales = [ "all" ];
    };

    services.xserver = {
      layout = config.resources.keyboard.layout;
      # Compose key list available at http://duncanlock.net/blog/2013/05/03/how-to-set-your-compose-key-on-xfce-xubuntu-lxde-linux/
      xkbOptions = config.resources.keyboard.xkbOptions;
    };

    time.timeZone = "Europe/Paris";

    security.pki.certificates = config.resources.pki.acrs;

    nix.settings.auto-optimise-store = true;
    nix.gc = { automatic = true; };
  };

}
