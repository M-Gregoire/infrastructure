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

  boot.kernelModules = [ "rbd" "ceph" ];

  environment.systemPackages = [ pkgs.usb-modeswitch pkgs.velero ];
  services.udev.extraRules = ''
    # If Modem in USB Storage mode, switch to 3G mode
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="15ca", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -v 12d1 -p 15ca -M '55534243123456780000000000000011062000000100000000000000000000'"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", RUN+="${pkgs.bash}/bin/bash -c 'modprobe option && echo 12d1 1506 > /sys/bus/usb-serial/drivers/option1/new_id'"

    # If Modem in 3G mode, make alias named ttyUSB-3G
    SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1506", SYMLINK+="ttyUSB-3G"

    # Make alias for bluetooth
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0a5c", ATTRS{idProduct}=="21e8", SYMLINK+="ttyUSB-Bluetooth"

    # Make alias for zigbee
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", SYMLINK+="ttyUSB-Zigbee"
  '';
}
