{ config, pkgs, options, ... }:

{
  imports = [
    ../modules
    ./dev/docker.nix
    ./dev/nfs.nix
    ./dev/openvpn-client.nix
    ./services.nix
  ];

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
    # Backup
    borgbackup
    # tmux
    tmux
  ];

  # Boot with last kernel
  # https://github.com/NixOS/nixpkgs/issues/30335
  # Check by comparing
  # file -L /run/current-system/kernel
  # uname -r
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Wifi
  environment.etc."wpa_supplicant.conf".source = "${config.resources.pcs.paths.secrets}/wpa_supplicant.conf";

  nix.nixPath = with builtins; options.nix.nixPath.default ++ [
    "nixos-config=${toPath "${config.resources.pcs.paths.publicConfig}/nixos/hosts/${config.resources.hostname}/configuration.nix"}"
  ];

  nixpkgs.config = import ../nixpkgs/config.nix;
  nixpkgs.overlays = import ../nixpkgs/overlays.nix;

  networking.hostName = config.resources.hostname;

  networking.firewall.allowedTCPPorts = config.resources.networking.firewall.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.networking.firewall.openUDPPorts;
  networking.firewall.allowedTCPPortRanges = config.resources.networking.firewall.openTCPPortsRange;
  networking.firewall.allowedUDPPortRanges = config.resources.networking.firewall.openUDPPortsRange;

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.hostname}" ];
    "::1" = [ "${config.resources.hostname}" ];
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
    extraGroups = [
      "users"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "fr_FR.UTF-8"; };
    supportedLocales = [ "all" ];
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
    xkbModel = "pc104";
    # Compose key list available at http://duncanlock.net/blog/2013/05/03/how-to-set-your-compose-key-on-xfce-xubuntu-lxde-linux/
    xkbOptions = "compose:ralt";
  };

  time.timeZone = "Europe/Paris";

  security.pki.certificates = config.resources.pki.acrs;
}
