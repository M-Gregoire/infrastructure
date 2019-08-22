{ config, pkgs, ... }:

{
  imports = [
    ../../dev/printing.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
    };
  };

  # Smart card
  services.pcscd.enable = true;

  programs.ssh.startAgent = false;

  # Kwallet was used for storing Nextcloud client identifiers
  # I now only use nextcloud through CLI so It's not needed
  #environment.systemPackages = with pkgs; [ libsForQt5.kwallet kwallet-pam kdeApplications.kwalletmanager ];
  #security.pam.services.lightdm.enableKwallet = true;

  # Ergodox
  services.udev.extraRules = ''
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"
  '';

  # gconf needed by thunderbird
  # See https://github.com/NixOS/nixpkgs/issues/13287
  # dconf needed by home-manager
  # See https://github.com/rycee/home-manager/pull/510
  services.dbus.packages = with pkgs; [ gnome3.dconf gnome2.GConf ];

  systemd.services.tasks = {
    description = "Sync taskwarrior tasks";
    serviceConfig.User = "${config.resources.host.username}";
    script = ''
      if ${pkgs.taskwarrior}/bin/task sync; then
        echo "Syncing success"
      else
        echo "Syncing fail: sending notification"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Taskwarrior sync failed" -F "message=An error occured while trying to sync local computer with taskd server" -F "priority=5"
      fi
    '';
    wantedBy = [ "default.target" ];
  };

  systemd.services.nixpkgs-update = {
    description = "Update nixpkgs release";
    serviceConfig.User = "${config.resources.host.username}";
    script = ''
      if [ -d '/home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}' ]; then
        if ${pkgs.git}/bin/git -C /home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}/vendor/nixpkgs-release fetch --all && ${pkgs.git}/bin/git -C /home/${config.resources.host.username}/src/github.com/${config.resources.git.username}/${config.resources.config.publicRepo}/vendor/nixpkgs-release checkout channels/nixos-19.03; then
          echo "nixpkgs-release updated"
        else
          echo "nixpkgs-release update failed: sending notification"
          ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Nixpkgs-release update failed" -F "message=Check systemctl for more information." -F "priority=5"
        fi
      else
        echo "public repo does not exists"
      fi
    '';
    wantedBy = [ "default.target" ];
    after = [ "network.target" ];
    requires = [ "network.target" ];
  };

  systemd.services.nextcloud = {
    description = "Sync nextcloud";
    serviceConfig.User = "${config.resources.host.username}";
    script = ''
      if ${pkgs.nextcloud-client}/bin/nextcloudcmd --non-interactive --silent --user ${config.resources.nextcloud.username} --password ${config.resources.nextcloud.password} ${config.resources.nextcloud.localFolder} ${config.resources.nextcloud.url}; then
        echo "Nextcloud syncing is done"
      else
        echo "Syncing fail: sending notification"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.gotify.url}/message?token=${config.resources.gotify.token}" -F "title=Nextcloud sync failed" -F "message=An error occured while trying to sync local computer with Nextcloud server" -F "priority=5"
      fi
    '';
    wantedBy = [ "default.target" ];
    requires = [ "network.target" ];
  };

  # systemctl list-timers

  systemd.timers.tasks = {
    description = "Sync tasks every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitInactiveSec = "5m";
    };
  };

  systemd.timers.nixpkgs-update = {
    description = "Update nixpkgs release every 3h";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "15m";
      OnUnitInactiveSec = "3h";
    };
  };

  systemd.timers.nextcloud = {
    description = "Sync nextcloud every minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitInactiveSec = "1m";
    };
  };
}
