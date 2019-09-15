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
  ];

  # Boot with last kernel
  # https://github.com/NixOS/nixpkgs/issues/30335
  # Check by comparing
  # file -L /run/current-system/kernel
  # uname -r
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.nixPath = with builtins; [
    "nixpkgs=${toPath "/home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}" + toPath /vendor/nixpkgs-release}"
    "nixos-config=${toPath "/home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}/nixos" + toPath "/hosts/${config.resources.host.name}/configuration.nix"}"
  ];

  nixpkgs.config = import ../nixpkgs/config.nix;
  nixpkgs.overlays = import ../nixpkgs/overlays.nix;

  networking.hostName = config.resources.host.name;
  networking.nameservers = config.resources.network.DNS;

  networking.firewall.allowedTCPPorts = config.resources.firewall.openTCPPorts;
  networking.firewall.allowedUDPPorts = config.resources.firewall.openUDPPorts;
  networking.firewall.allowedTCPPortRanges = config.resources.firewall.openTCPPortsRange;
  networking.firewall.allowedUDPPortRanges = config.resources.firewall.openUDPPortsRange;

  networking.hosts = {
    "127.0.0.1" = [ "${config.resources.host.name}" ];
    "::1" = [ "${config.resources.host.name}" ];
  };

  users.users.${config.resources.host.username} = {
    isNormalUser = true;
    home = "/home/${config.resources.host.username}";
    extraGroups = [
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.resources.ssh.publicKeys;
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
