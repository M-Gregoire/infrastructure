{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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

  networking.hostName = "nixos-tmp";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [ git ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCj79SiNMAbXEwz10p1+qxjfQHLcK/+/qSLZmnRaskKR5pEUVSzXQ6kX3dBoXrz2TFV5UJ2Y//LtUJzOLMTYcDC3hBOrsl/9wp8TzirVqlmRH1wgx6loH6y4rJM5N3dAqigKa+Pnop3HXb7ea14/vnf5RaFpjdPxRZOVJm7BoTmMa5R1HbJkCkYqvLtuLtLDaprgDwaCH8fE6/c3FTln3WGe/u71c+WT2IFJgtqOuFwuKyOmGy8t4Iu1lN6ULBZWs0lGt+5jzc6N21PJQvxHkgLMNZgFMJYLzDFcSB2M5jZwqAUoPQl2GOHcKuej5apxxBvMzPMYO1p3PZKaws8ujtx gm" ];

  system.stateVersion = "18.09";

  # For SSH
  # https://askubuntu.com/questions/54145/how-to-fix-strange-backspace-behaviour-with-urxvt-zsh
  environment.variables.TERM = "xterm";

}
