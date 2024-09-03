{ config, pkgs, lib, private-config, ... }: {
  imports = [

    (import ../../../common.nix {
      inherit config pkgs lib private-config;
      hostname = "hades-2";
      cluster = "hades";
      clusterRole = "agent";
      profile = "server";
      network = "home";
    })
    ./hardware-configuration.nix
  ];

  system.stateVersion = "20.03";

  boot.loader.grub.enable = false;
  # boot.loader.grub.device = "/dev/mmcblk2"; # or "nodev" for efi only

  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # systemd.network.netdevs = {
  #   "10-enu1u1u1.50" = {
  #     netdevConfig = {
  #       Name = "enu1u1u1.50";
  #       Kind = "vlan";
  #     };
  #     vlanConfig = { Id = 50; };
  #   };
  # };

  # systemd.network.networks = {
  #   "11-enu1u1u1" = {
  #     matchConfig.Name = "enu1u1u1";
  #     vlan = [
  #       "enu1u1u1.50"
  #     ];
  #     dhcpConfig = { UseDNS = true; };
  #     networkConfig = { DHCP = "yes"; };
  #     linkConfig = { RequiredForOnline = true; };

  #     routes = [{ routeConfig.Gateway = "192.168.3.1"; }];
  #   };

  #   "12-enu1u1u1.50" = {
  #     matchConfig.Name = "enu1u1u1.50";
  #     address = [ "192.168.5.50" ];
  #     gateway = [ "192.168.5.1" ];
  #     linkConfig = { MACAddress = "11:22:33:44:55:66"; };
  #   };
  # };

  services.k3s = {
    enable = true;
    role = "agent";
  };

  environment.systemPackages = [ pkgs.k3s pkgs.containerd pkgs.kubectl ];
  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.udev.extraRules = ''
    # Make alias for zigbee
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", SYMLINK+="ttyUSB-Deconz-Zigbee"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="0001", SYMLINK+="ttyUSB-Sonoff-Zigbee-Green"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="8cd70e123486ec11ab32591719c2d21c", SYMLINK+="ttyUSB-Sonoff-Zigbee-Red"

    # # Make alias for bluetooth
    # # SUBSYSTEM=="tty", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="21e8", SYMLINK+="ttyUSB-Pluggable-Bluetooth"

    # Get info with udevadm info --attribute-walk /dev/tty...
    # If Modem in USB Storage mode, switch to 3G mode
    # Requires `usb-modeswitch`
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="15ca", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 12d1 -p 15ca -M '55534243123456780000000000000011062000000100000000000000000000'"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", RUN+="${pkgs.bash}/bin/bash -c 'modprobe option && echo 12d1 1506 > /sys/bus/usb-serial/drivers/option1/new_id'"

    # If Modem in 3G mode, make alias named ttyUSB-Huawei-3G
    SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", SYMLINK+="ttyUSB-Huawei-3G"
  '';
}
