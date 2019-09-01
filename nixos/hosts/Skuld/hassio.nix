{ config, pkgs, ... }:

{
  ##########################################################
  #                                                        #
  #   This file explain how Hassio can be used on NixOS    #
  #   by manually defining the services. However, I now    #
  #   use hassio-compose which is easier to maintain. I    #
  #   leave this file for documentation purposes.          #
  #                                                        #
  ##########################################################


  # Download install script for hassio
  # wget "https://raw.githubusercontent.com/home-assistant/hassio-installer/master/hassio_install.sh"
  # Remove service creation from script

  # Install with cat hassio_install.sh | bash -s -- -d /path/to/data/folder -s /path/to/sysconfdir
  # Note: sysconfdif must exists!

  environment.systemPackages = with pkgs; [
    jq
    avahi
    #apparmor-parser
  ];

  # Unfortunately, there is currently no systemd-networkd support
  # Hassio uses network manager
  networking.networkmanager.enable = true;
  # Network manager don't modify dns
  networking.networkmanager.dns = "none";
  networking.networkmanager.unmanaged = [ "docker0" ];
  networking.nameservers = config.resources.network.dns;
  # https://github.com/moby/moby/issues/32836
  # https://people.freedesktop.org/~lkundrak/nm-docs/NetworkManager.conf.html
  networking.networkmanager.extraConfig = ''
    [main]
    rc-manager=file
  '';

  security.apparmor = {
    enable = true;
    # Download profile at https://version.home-assistant.io/apparmor.txt
    profiles = [ "/root/apparmor.txt" ];
  };

  # Implement https://raw.githubusercontent.com/home-assistant/hassio-installer/master/files/hassio-supervisor.service
  systemd.services.hassio-supervisor = {
    description = "Hass.io supervisor";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      ExecStartPre="${pkgs.docker}/bin/docker stop hassio_supervisor";
      ExecStart="/usr/sbin/hassio-supervisor";
      ExecStop="${pkgs.docker}/bin/docker stop hassio_supervisor";
    };
    requires = [ "docker.service" ];
    after = [ "docker.service" "dbus.socket" ];
    wantedBy = [ "multi-user.target" ];
  };

  # No support for AppArmor yet
  # Implement https://raw.githubusercontent.com/home-assistant/hassio-installer/master/files/hassio-apparmor.service
  systemd.services.hassio-apparmor = {
    description = "Hass.io AppArmor";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "true";
      ExecStart = "/usr/sbin/hassio-apparmor";
    };
    wants = [ "hassio-supervisor.service" ];
    before = [ "docker.service" "hassio-supervisor.service" ];
    wantedBy = [ "multi-user.target" ];
  };
}
