{ config, pkgs, ... }:

{
  imports = [
    ../../dev/printing.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = config.resources.username;
      };
    };
  };

  # Smart card
  services.pcscd.enable = true;

  # Use gpg agent instead of ssh agent
  programs.ssh.startAgent = false;

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
    serviceConfig.User = "${config.resources.username}";
    script = ''
      if ${pkgs.taskwarrior}/bin/task sync; then
        echo "Syncing success"
      else
        echo "Syncing fail: sending notification"
        ${pkgs.curl}/bin/curl -X POST "${config.resources.services.gotify.url}/message?token=${config.resources.services.gotify.token}" -F "title=Taskwarrior sync failed" -F "message=An error occured while trying to sync local computer with taskd server" -F "priority=5"
      fi
    '';
    wantedBy = [ "default.target" ];
  };
  # systemctl list-timers

  systemd.timers.tasks = {
    description = "Sync tasks every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitInactiveSec = "5m";
    };
  };
}
