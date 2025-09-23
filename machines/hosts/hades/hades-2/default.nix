{ config, pkgs, lib, inputs, ... }: {
  imports = [

    ./hardware-configuration.nix
  ];

  environment.etc."machine-id".text = "f3d7c3045ab04400a4f4735d8223be7e";

  system.stateVersion = "20.03";

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [
    "cgroup_enable=memory"
    "cgroup_memory=1"
    "systemd.unified_cgroup_hierarchy=1"
  ];

  services.k3s = {
    enable = true;
    role = "agent";
  };

  environment.systemPackages = with pkgs; [
    # libraspberrypi
    # raspberrypi-eeprom
    k3s
    containerd
    kubectl
    usb-modeswitch
  ];

  networking.firewall.allowedTCPPorts = [ 6443 ];

  services.udev.extraRules = ''
    # Make alias for zigbee
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="0001", SYMLINK+="ttyUSB-Sonoff-Zigbee-Green"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="8cd70e123486ec11ab32591719c2d21c", SYMLINK+="ttyUSB-Sonoff-Zigbee-Red"
  '';
}
