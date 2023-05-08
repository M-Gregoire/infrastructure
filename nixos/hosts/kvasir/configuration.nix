{ config, pkgs, ... }:

{
  imports = [
    ../../../resources/hosts/kvasir
    ../../../vendor/infrastructure-private/resources/hosts/kvasir
    ../../common.nix
    ../../dev/k3s.nix
    ../../dev/bluetooth.nix
    ../../dev/boot/grub-bios.nix
    ../../networks/home
    ../../profiles/Server
    ./hardware-configuration.nix
  ];

  networking.firewall.allowedTCPPorts =
    [ config.resources.hosts.kvasir.ssh.port ];
  services.openssh.ports = [ config.resources.hosts.kvasir.ssh.port ];

  system.stateVersion = "20.03";
  networking.firewall.enable = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  boot.kernelModules = [ "nbd" "rbd" "ceph" ];

  environment.systemPackages = [ pkgs.usb-modeswitch pkgs.velero ];
  services.udev.extraRules = ''
    # Get info with udevadm info --attribute-walk /dev/tty...
    # If Modem in USB Storage mode, switch to 3G mode
    # /!\ Done at Proxmox level for Huawei (Hotplugging not supported, device reset often)
    # /etc/udev/rules.d/huawei.rules
    # Requires `sudo apt-get install usb-modeswitch`
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="15ca", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 12d1 -p 15ca -M '55534243123456780000000000000011062000000100000000000000000000'"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", RUN+="${pkgs.bash}/bin/bash -c 'modprobe option && echo 12d1 1506 > /sys/bus/usb-serial/drivers/option1/new_id'"

    # If Modem in 3G mode, make alias named ttyUSB-Huawei-3G
    SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", SYMLINK+="ttyUSB-Huawei-3G"

    # Make alias for bluetooth
    # SUBSYSTEM=="tty", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="21e8", SYMLINK+="ttyUSB-Pluggable-Bluetooth"

    # Make alias for zigbee
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", SYMLINK+="ttyUSB-Deconz-Zigbee"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="0001", SYMLINK+="ttyUSB-Sonoff-Zigbee-Green"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="8cd70e123486ec11ab32591719c2d21c", SYMLINK+="ttyUSB-Sonoff-Zigbee-Red"
    # Make alias for Google Coral
    # SUBSYSTEM=="tty", ATTRS{idVendor}=="1a6e", ATTRS{idProduct}=="089a", SYMLINK+="ttyUSB-Google-Coral"
  '';
}
