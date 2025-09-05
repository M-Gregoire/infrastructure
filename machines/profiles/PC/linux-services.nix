{ config, pkgs, ... }:

{
  imports = [ ../../dev/linux/yubikey.nix ];

  services = {

    libinput = {
      # Enable libinput
      enable = true;
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.resources.username;
      };
    };
    xserver = {
      enable = true;
      displayManager = { lightdm = { enable = true; }; };
      desktopManager.session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }];

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
  services.dbus.packages = with pkgs; [ dconf gnome2.GConf ];

  # dconf needed for wpgtk
  # https://nixos.wiki/wiki/Wpgtk
  programs.dconf.enable = true;

  # systemctl list-timers

  systemd.user = {
    services.nextcloud-autosync = {
      enable = true;
      description = "Auto sync Nextcloud";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        Type = "simple";
        # TODO: Remove Grégoire
        ExecStart =
          "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /org ${config.resources.paths.home}/org ${config.resources.services.nextcloud.url}";
        TimeoutStopSec = "180";
        # KillMode = "process";
        # KillSignal = "SIGINT";
      };
      wantedBy = [ "multi-user.target" ];
    };
    timers.nextcloud-autosync = {
      description =
        "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 5 minutes";
      timerConfig = {
        OnUnitActiveSec = "5min";
        OnBootSec = "5min";
        Unit = "nextcloud-autosync.service";
      };
      wantedBy = [ "multi-user.target" "timers.target" ];
    };
  };
}
