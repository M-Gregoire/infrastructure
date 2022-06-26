{ config, pkgs, ... }:

{
  imports = [ ../../dev/printing.nix ../../dev/yubikey.nix ];

  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = { enable = true; };
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
  services.dbus.packages = with pkgs; [ dconf gnome2.GConf ];

  # dconf needed for wpgtk
  # https://nixos.wiki/wiki/Wpgtk
  programs.dconf.enable = true;

  # systemctl list-timers

  systemd.timers.tasks = {
    description = "Sync tasks every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = { OnUnitInactiveSec = "5m"; };
  };
}
