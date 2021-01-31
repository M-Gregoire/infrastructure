{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # LUKS
  #boot.initrd.luks.devices = {
  #  root = {
  #    device = "/dev/sda2";
  #    preLVM = true;
  #  };
  #};

  # BIOS
  #boot.loader.grub = {
  #  enable = true;
  #  version = 2;
  #  device = "/dev/sda";
  #};

  # UEFI
  boot.loader.systemd-boot.enable = true;
  # General settings
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;
  # GRUB
  boot.loader.grub = {
    enable = true;
    configurationLimit = 100;
    efiSupport = true;
    device = "nodev";
    # Install in UEFI mode from device booted in legacy
    #efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "nixos-tmp";
    # wpa_passphrase $SSID $PASSPHRASE > /etc/wpa_supplicant.conf
    wireless.enable = true;
    # This is used to be able to deploy locally with nixops from temporary system.
    hosts = {
      "127.0.0.1" = [ "Bur" "Mimir" ];
    };
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [ git nixops ];

  services.openssh = {
    enable = true;
    ports = [ 5421 ];
    permitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3dchSro0m3PmK0ZjxwRZ7kthxIzVU6T+apdG09/7vH/TS9UfoAB3fSUs80dplXB6UxzRmqNdqh5vHd9SUMre/S8NPmFCwwM98bqUNCNx6ZMwstSY/15PCVUkQk8fBXI4L/eUvYGpkBX3jjvqp75XWR8yIvx7l6189ljmt4Wrt1p6gUxJKRO8PjZxFHriAykNOC+MtOkjseT0iK//ij7XYj6zYq1fQLw92lB4AWgw3dvRmhag79yHeKVT2zCBD4zw8q9gAGIp6vc+5L3X/5q2i8wm9hh/TeBY3IhFOiMzzYbPMWIjsx4tk6iUv2Gtpdp/B0Nx/FnlEtS1MZeWfjwA6vQFWS/G/OPM2SHbUmzgJ4lufm2yEj67P0vGSPvHg7uonxhf5OVf8J+p8bmVC5s4SEG5aKuBN/+9El71joN7491+mEWGAl0PqJbDU5UEC6wYigx2wAUVtF3mB5QtbKiZ5UYVly/u+ejACr+K2651+EEAqjPx4xrRm9tlLn2LslMCuRQ2QDzOcl5iM3ZkCbAHIFS8ZGc94w84SNL22jV6kPLcrs8S5isO79cDYuxqUM/Aa3VpYuminpUFNEPYy25UjNtWZUFp2kef1JP9dAD27pWCW1Nlgc0SqmEusBsvflzdQmhvCZuBCU/Xy16WPb2WL8lxcCZVuQvcPKz3dgGQD5w== m-gregoire"
  ];

  system.stateVersion = "19.03";

  # For SSH
  # https://askubuntu.com/questions/54145/how-to-fix-strange-backspace-behaviour-with-urxvt-zsh
  environment.variables.TERM = "xterm";
}
