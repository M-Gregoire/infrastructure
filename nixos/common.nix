{ config, pkgs, ... }:

{
  imports = [
    ../modules
    ./dev/docker.nix
    ./services.nix
  ];

  environment.systemPackages = with pkgs; [
    file
    bc
    parted
    # DNS utils (dig)
    dnsutils
    # htop
    htop
  ];

  # Boot with last kernel
  # https://github.com/NixOS/nixpkgs/issues/30335
  # Check by comparing
  # file -L /run/current-system/kernel
  # uname -r
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Wifi
  environment.etc."wpa_supplicant.conf".source = "${config.resources.pcs.paths.secrets}/wpa_supplicant.conf";

  nix.nixPath = with builtins; [
    "nixpkgs=${toPath "${config.resources.pcs.paths.publicConfig}/vendor/nixpkgs-release"}"
    "nixos-config=${toPath "${config.resources.pcs.paths.publicConfig}/nixos/hosts/${config.resources.hostname}/configuration.nix"}"
  ];

  nixpkgs.config = import ../nixpkgs/config.nix;
  nixpkgs.overlays = import ../nixpkgs/overlays.nix;

  networking.hostName = config.resources.hostname;
  networking.nameservers = config.resources.networking.DNS;

  networking.firewall.allowedTCPPorts = config.resources.networking.firewall.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.networking.firewall.openUDPPorts;
  networking.firewall.allowedTCPPortRanges = config.resources.networking.firewall.openTCPPortsRange;
  networking.firewall.allowedUDPPortRanges = config.resources.networking.firewall.openUDPPortsRange;

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.hostname}" ];
    "::1" = [ "${config.resources.hostname}" ];
  };

  users.users.${config.resources.username} = {
    isNormalUser = true;
    home = "/home/${config.resources.username}";
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_MESSAGES = "en_US.UTF-8"; LC_TIME = "fr_FR.UTF-8"; };
    supportedLocales = [ "all" ];
    # TODO: Consider this option
    #consoleUseXkbConfig = true;
  };

  time.timeZone = "Europe/Paris";

  # Needed for LightDM to remember the user
  # See https://github.com/NixOS/nixpkgs/issues/10349#issuecomment-341810990
  programs.zsh.enable = true;
  # For SSH
  # https://askubuntu.com/questions/54145/how-to-fix-strange-backspace-behaviour-with-urxvt-zsh
  # Proper way is to use terminfo
  #environment.variables.TERM = "xterm";
}
